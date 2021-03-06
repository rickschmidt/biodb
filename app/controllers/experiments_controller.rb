class ExperimentsController < ApplicationController
  before_filter :require_user
  # GET /experiments
  # GET /experiments.xml
  helper_method :sort_column, :sort_direction
  helper :all
  def index

    
     @per_page = params[:per_page] || Experiment.per_page || 10
      @search=Experiment.search(params[:search])
      @experiments=@search.find(:all,:order=>(sort_column + " "+ sort_direction)).paginate(:per_page => @per_page, :page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @experiments }
    end
  end

  # GET /experiments/1
  # GET /experiments/1.xml
  def show
    @ids=Array.new
    @pcrsAll=Pcr.find(:all)
    @dnasamples=Dnasample.find(:all)
    @pcrs=Hash.new
    @experiments=Experiment.find(:all, :limit=>15 )
    @experiment=Experiment.find(params[:id])
    @dnasamples=@experiment.dnasamples
    @experiment.pcrs.each do |pcr|
      @pcrs[pcr]=pcr.dnasamples.first
      logger.debug "pcrs in exp show #{@pcrs.inspect}"
      # pcr.dnasamples.each do |dna|
      #   @ids<<dna
      # end
    end
    @experiment.update_attributes(:total_samples=>@pcrs.size)
    respond_to do |format|
      format.html # show.html.erb
      format.pdf {render :pdf =>{:experiment=>@experiment, :pcrs=>@pcrs}}
      format.xml  { render :xml => @experiment }
      format.js
    end
  end

  # GET /experiments/new
  # GET /experiments/new.xml
  def new
    @experiment = Experiment.new
    @pcrsAll=Pcr.find(:all)
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @experiment }
    end
  end

  # GET /experiments/1/edit
  def edit
    @experiment = Experiment.find(params[:id])
  end

  # POST /experiments
  # POST /experiments.xml
  def create
    @experiment = Experiment.new(params[:experiment])
    
    # if params[:gene][:primer]!=""
    #         @primer=Primer.find(params[:gene][:primer])
    #         @experiment.primerh=@primer.primerh
    #         @experiment.primerl=@primer.primerl
    #     end
    respond_to do |format|
      if @experiment.save
        format.html { redirect_to(@experiment, :notice => 'Experiment was successfully created.') }
        format.xml  { render :xml => @experiment, :status => :created, :location => @experiment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @experiment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /experiments/1
  # PUT /experiments/1.xml
  def update
    @experiment = Experiment.find(params[:id])
     # if params[:gene][:primer]!=""
     #       @primer=Primer.find(params[:gene][:primer])
     #       @experiment.primerh=@primer.primerh
     #       @experiment.primerl=@primer.primerl
     #   end

    respond_to do |format|
      if @experiment.update_attributes(params[:experiment])
        format.html { redirect_to(@experiment, :notice => 'Experiment was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @experiment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /experiments/1
  # DELETE /experiments/1.xml
  def destroy
    @experiment = Experiment.find(params[:id])
    @experiment.destroy

    respond_to do |format|
      format.html { redirect_to(experiments_url) }
      format.xml  { head :ok }
    end
  end
  
  
  def updatepcr
    experiment=Experiment.find(params[:id])
    pcrs=experiment.pcrs
    dnasamples=pcrs.dnasamples
    render :update do |page|
      page.replace_html 'pcrs', :partial => 'pcrs', :object => pcrs
    end
    pcr=Pcr.find(params[:id])
    logger.debug "PCR PCR, #{pcr}"
    @dnasamples=Array.new
    pcr.dnasamples.each do |dna|
      @dnasamples<<dna
    end
#    render :partial => 'dnasamples'
    @pcr = Pcr.find(params[:experiment][:state])

  end
  
  def updatednasamples

    logger.debug "update sample id is #{params[:id]}"
    pcr=Pcr.find(params[:id])
    @dnasamples=Array.new
    pcr.dnasamples.each do |dna|
      @dnasamples<<dna
    end
    dnasamples=pcr.dnasamples
    logger.debug "dna samples #{@dnasamples}"
    render :update do |page|
      page.replace "dnasamples_#{experiment.id}", :partial => 'dnasamples', :object => @dnasamples

    end
  
  end
  
  def genes
    dnasample=Dnasample.find(params[:id])
    @gene=Array.new
    dnasample.genes.each do |gene|
      @gene<<gene
      logger.debug "gene is #{gene}"
    end
    @gene=@gene[0]
    if @gene
      @hprimer=@gene.primerh
    end

    render :update do |page|
      page.replace 'lprimer', :partial => 'genes', :object=>@gene
      page.replace 'hprimer', :partial=>  'hprimer', :object=>@hprimer  
    end
  end
  
  def submit
    
    
  end
  
  def getpcrtube
     @pcr=Pcr.find(params[:id]) 
     @experiment=Experiment.find(params[:experimentId])
    if @pcr.dnasamples.first
        @dnasample=@pcr.dnasamples.first
    end
    flash[:error] = "No DNA Sample associated with this project"
        

   
      respond_to do |with|
            with.js
                    logger.debug "here"
                end

      
  end
    def savepcrtubes
       @pcrsAll=Pcr.find(params[:id])
        logger.debug "pcrs all in savepcrtubes #{@pcrsAll.inspect}"
        @experiment=Experiment.find(params[:experimentId])
        @experiment.pcrs<<@pcrsAll
        logger.debug "successful pcrs #{params[:successfulPcrs]}"
        # @successfulPcrs=Pcr.find(params[:successfulPcrs])
        #     @successfulPcrs.each do |successful|
        #         successful.update_attributes(:success=>true)
        #     end
        render :nothing => true

    end
    
    def updatesuccess
        @checked=params[:checked]
        @pcr=Pcr.find_by_pcr_tube_number(params[:tube])
        logger.debug "The value of tube #{@pcr.pcr_tube_number} should be set to #{@checked.to_s}."
        @pcr.update_attributes(:success=>@checked.to_s)
        logger.debug "checked is #{@checked.to_s}"
        logger.debug "The value of tube #{@pcr.pcr_tube_number} is now reading as #{@pcr.success}."
        
       render :nothing=>true 
    end
    
    def updateready
        @checked=params[:checked]
        @pcr=Pcr.find_by_pcr_tube_number(params[:tube])
        logger.debug "The value of tube #{@pcr.pcr_tube_number} should be set to #{@checked.to_s}."
        @pcr.update_attributes(:ready=>@checked)
        logger.debug "checked is #{@checked.to_s}"
        logger.debug "The value of tube #{@pcr.pcr_tube_number} is now reading as #{@pcr.ready}."
        
       render :nothing=>true 
    end
    
    def sequencelayout
#       @experiments=Experiment.find(params[:experimentssequence])
        @experiment=Experiment.find(params[:experimentId])
        logger.debug "The experiment is #{@experiment.id}."
       @experimentspcr=@experiment.pcrs

       @successful=@experimentspcr.find(:all, :conditions=>{:ready=>true})
       
       @successful.each do |s|
           logger.debug "The successful pcrs are...#{s.id}"
       end
       respond_to do |with|
           with.html
       end
   
      
    end
    
    
    def getdnasample
        @experiment=Experiment.find(params[:experimentId])
        @dnasample=Dnasample.find(params[:id]) 
        
        respond_to do |with|
            with.js
        end
        
        
    end
    
  private 
   def sort_column
       Experiment.column_names.include?(params[:sort]) ? params[:sort] : "date"
     end

     def sort_direction
       %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
     end
end
