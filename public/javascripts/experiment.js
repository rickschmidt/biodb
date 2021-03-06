//Experiment views

//Sets up AJAX request to accept js
jQuery.ajaxSetup({  
    'beforeSend': function (xhr) {xhr.setRequestHeader("Accept", "text/javascript")}  
}); 


//
$(document).ready(function (){  

        //Executes everytime the experiment pcr tube select box changes
        //Used to remove previous messages
        $('button.message').live('click',function(){
            $('p.message').remove();
          
        });
        
        $('select#experiment_dnasamples').live('change',function(){
             dataString = jQuery('tr.exp:last').find('select#experiment_dnasamples').val();
              var currentExperiment=$('input#experimentId').val();
              
              $.ajax({
                  url: "/experiments/getdnasample",
                  type:"POST",
                  data:{id:dataString,experimentId:currentExperiment},
                  
                  success: function(json,textStatus){
                      var obj=jQuery.parseJSON(json);
                      var index = jQuery('tr.exp:last').index();
                      var myDiv = jQuery('tr.exp:last').clone().attr('id',index);
                      
                    $('.dna:last').attr('id',index).html(obj.dna);
                     myDiv.appendTo('table.custom');
                  }
              });
        });
        
        //Runs when pcr tube select is changed
     $('select#experiment_pcrs').live('change',function (){

      dataString = jQuery('tr.exp:last').find('select#experiment_pcrs').val();
      success=jQuery('tr.exp:last').find('select#pcr_success').val();
      var currentExperiment=$('input#experimentId').val();
      
         $.ajax({
          url: "/experiments/getpcrtube",
          type: "POST",
          data: {id:dataString,experimentId:currentExperiment},
    
          success: function(json,textStatus){

             var obj = jQuery.parseJSON(json);
             var index = jQuery('tr.exp:last').index();
             var myDiv = jQuery('tr.exp:last').clone().attr('id',index);
             
             $('.primerh:last').attr('id',index).html(obj.primerh);
             $('.dna:last').attr('id',index).html(obj.dna);
             $('.primerl:last').attr('id',index).html(obj.primerl);
             $('.success:last').attr('id',index);
             $('select#experiment_pcrs').attr('disabled', 'disabled');
             myDiv.appendTo('table.custom');
                         $('p.message#errorExplanation').remove();
            $('.totalSamples').html(obj.total_samples);
             

          },
          
          error: function(json,textStatus){
              $('tr.exp:last select#experiment_pcrs').val(0);
                                       $('p.message').remove();
              $('<p class="message" id="errorExplanation">Error1: No DNA Sample is associated witht that PCR Tube.<button class="message"><p id="cancel">x</p></button></p>').appendTo('#messages').fadeIn(slow);

          }

      });
     
    });
    
    // $('select#pcr_success').live('change', function(){
    // 
    //     
    //         var currentId = $(this).parent().parent();
    //         var row_idx = currentId.prevAll().length;
    //         alert(row_idx);
    //         var tubeid=$(this).parent().parent().find('.custom').find('select#experiment_pcrs').val();
    //         var tubeidPrev=$(this).parent().parent().find('.customPrev').html();
    //         if(tubeid!=null){
    //         alert(tubeid);
    //         }
    //         if(tubeidPrev){
    //             alert(tubeidPrev);
    //         }
    //         
    // 
    //     });
    //Runs if Success check box is changed
    $('input#pcr_pcr_success').click(function() {
        var checked=this.checked
       
        var currentId = $(this).parent().parent();
        var row_idx = currentId.prevAll().length;
       
        var tubeid=$(this).parent().parent().find('.custom').find('select#experiment_pcrs').val();
        var tubeidPrev=$(this).parent().parent().find('.customPrev').html();
        if(tubeid!=null){
            var tube=tubeid;
       
        }
        if(tubeidPrev!=null){
            var tube=tubeidPrev;
            
        }
        
         $.ajax({
            url: "/experiments/updatesuccess",
            type: "POST",
            data:{checked:checked,tube:tube},
            
            success: function(json,textStatus){
                
            },
            error: function(json,textStatus){
                
            }
        });
        
    });
    
    //Runs if Ready check box is changed
    $('input#pcr_pcr_ready').click(function() {
        var checked=this.checked
         
        var currentId = $(this).parent().parent();
        var row_idx = currentId.prevAll().length;
        
        var tubeid=$(this).parent().parent().find('.custom').find('select#experiment_pcrs').val();
        var tubeidPrev=$(this).parent().parent().find('.customPrev').html();
        if(tubeid!=null){
            var tube=tubeid;
        
        }
        if(tubeidPrev!=null){
            var tube=tubeidPrev;
        
        }
        
         $.ajax({
            url: "/experiments/updateready",
            type: "POST",
            data:{checked:checked,tube:tube},
            
            success: function(json,textStatus){
        
            },
            error: function(json,textStatus){
                alert(textStatus);
            }
        });
        
    });
    
    //Runs if saved button is clicked
    $('button.save').live('click', function(){
        var pcrs=new Array();
        var successfulPcrsArray=new Array();
        var currentExperiment=$('input#experimentId').val();

        $('tr#.exp').each(function (i){
            
            var selpcr=$('select#experiment_pcrs').val();
            if(selpcr!=''){
                pcrs[i]=selpcr;
            
                var x=$('select#pcr_success').val();

                
                if(x=="1"){

                        var id=$('select#pcr_success').val();

                          successfulPcrsArray[i]=id;

                    
                }
            }
            
            
        });
      
        $.ajax({
            url: "/experiments/savepcrtubes",
            type: "POST",
            data:{id:pcrs,experimentId:currentExperiment,successfulPcrs:successfulPcrsArray},
            
            success: function(json,textStatus){

                $('p.message#errorExplanation').remove();
                 $('<p class="message" id="success">PCR Tubes saved to this experiment.<button class="message"><p id="cancel">x</p></button></p>').appendTo('#messages').fadeIn(slow);
            },
            
            error: function(json,textStatus){

                $('p.message').remove();
              $('<p class="message" id="errorExplanation">Error: No DNA Sample is associated witht that PCR Tube.<button class="message"><p id="cancel">x</p></button></p>').appendTo('#messages').fadeIn(slow);
            }
        });


    });
    
    
    

}); //end docuement ready 


























