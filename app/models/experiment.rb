class Experiment < ActiveRecord::Base
  has_and_belongs_to_many :pcrs
  has_and_belongs_to_many :dnasamples#, :through=>:pcrs
  
  validates_presence_of :experiment_number
  validates_uniqueness_of :experiment_number
  
  
  
  

  def self.search(search)
        if search
          
          Experiment.experiment_number_or_date_or_anneal_or_dna_amount_or_total_samples_or_notes_or_bsa_or_buffer_or_mgcl2_or_taq_or_dntps_or_dna_or_primerl_amount_or_primerh_amount_or_total_or_primerl_or_primerh_like_any(search)
        else
          @search=Experiment.experiment_number_like("")
          
        end
      end
end
