//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require jquery-ui-i18n

//= require twitter-bootstrap/bootstrap-transition
//= require twitter-bootstrap/bootstrap-alert
//= require twitter-bootstrap/bootstrap-modal
//= require twitter-bootstrap/bootstrap-dropdown
//= require twitter-bootstrap/bootstrap-scrollspy
//= require twitter-bootstrap/bootstrap-tab
//= require twitter-bootstrap/bootstrap-tooltip
//= require twitter-bootstrap/bootstrap-popover
//= require twitter-bootstrap/bootstrap-button
//= require twitter-bootstrap/bootstrap-collapse
//= require twitter-bootstrap/bootstrap-carousel
//= require twitter-bootstrap/bootstrap-typeahead
//= require twitter-bootstrap/extensions/bootstrap-fileupload
//= require twitter-bootstrap/extensions/bootstrap-inputmask
//= require twitter-bootstrap/extensions/bootstrap-rowlink

//= require markitup/jquery.markitup
//= require markitup/sets/default/set
//= require chosen.jquery.min


/* Active Admin JS */
$(function(){
  // Chosen Applications
  $('select').chosen();
	
  // datepicker for filters ---------------------------------------------------
  $(".datepicker").datepicker($.datepicker.regional[$('html').attr('lang')]);

  // from active admin --------------------------------------------------------
  $(".clear_filters_btn").click(function(){
    window.location.search = "";
    return false;
  });
  
  // editor --------------------------------------------------------------------
  mySettings.previewTemplatePath =	'/admin/preview';
  mySettings.previewInWindow = 'width=800, height=600, resizable=yes, scrollbars=yes';
  $('.editor').markItUp(mySettings);
  
  // yeah I know... I will refactor it sometime -----------------------------------
  $('.sidebar.modal form .filter_form_field').wrapAll('<div class="modal-body"/>');
  $('.sidebar.modal form .filter_form_field label').removeClass('label');
   
  // bootstrap expects '...' on pagination to be an anchor
  $('.page.disabled').wrapInner('<a/>') ;
   
  // thumbnails on forms-----------------------------------------------------------
  $('form .thumbnail').each(function(){
    var img = $(this).find('img');
    
    if (img.length) {
      img.appendTo($(this).find('div:first'));
      img.wrap('<figure/>');
      img.parent().append('<a class="remove">Remove</a>');
  
      var that= this;
      $(this).find('.remove').click(function(){
        $(that).find('figure').hide();
        $(that).find('input').show()
      });
      
      $(this).find('input').hide()
    }
  });
});

