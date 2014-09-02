$(document).ready () ->

  # Reroute external links
  $('a').each () ->
     if $(this).attr('href') && $(this).attr('href') != '#'
       match = $(this).attr('href').match(/^([^:\/?#]+:)?(?:\/\/([^\/?#]*))?([^?#]+)?(\?[^#]*)?(#.*)?/)
       if (typeof match[1] == "string" && match[1].length > 0 && match[1].toLowerCase() != location.protocol) || (typeof match[2] == "string" && match[2].length > 0 && match[2].replace(new RegExp(":("+{"http:":80,"https:":443}[location.protocol]+")?$"), "") != location.host)
         $(this).attr('target','_blank')

  # Validation for email subscription form
  $('#navigation .subscribe').validate
    rules:
      'EMAIL':
        required: true
        email: true
    messages:
      'EMAIL':
        required: 'Please enter your email address.'
        email: 'Please enter a valid email address.'

  # Validation for email results from CYOA form
  $('#cyoa-email').validate
    rules:
      'maile':
        required: true
        email: true
    messages:
      'maile':
        required: 'Please enter your email address.'
        email: 'Please enter a valid email address.'
    submitHandler: (form) ->
      email = $('#cyoa-email').find('.input-text').val()
      # Note: the 'email' input is a honeypot for spambots;
      # actual data is in 'maile', and 'email' should always be blank if we're not a robot.
      $.ajax
        type: 'POST'
        url: '/wp-content/themes/floodhelpny-wp/ajax/email_cyoa_results.php'
        data:
          maile: $('#cyoa-email').find('.input-text').val()
          results: questionData
          location: box || null
        success: (data) ->
          $('#cyoa-email').replaceWith "<div id=\"cyoa-email-sent\"><strong>Sent!</strong><br/>Your results have been sent to #{email}.</div>"
      false



  # Mobile menu opening
  $('#navigation').on 'click', 'li:first-child a', (event) ->
    $(event.currentTarget).toggleClass('open').closest('ul').toggleClass('open')

  # Expanding sections
  $('#content .column-right p a[href="#"]').unwrap()
  $('#content .column-right a[href="#"]').addClass('expand').removeAttr('href').find('br').remove().end().append('&nbsp;<span class="plus">[+]</span><span class="plus" style="display:none;">[-]</span>').each () ->
    set = $()
    next = this.nextSibling
    while next
      if !$(next).hasClass('expand') && !($(next).is('p') && $(next).find('a').length == 1)
        set.push next
        next = next.nextSibling
      else
        break
    set.wrapAll('<div class="expand-section" />')
  $('.expand').each () ->
    if $(this).text().indexOf('Zone') >= 0 || $(this).text().indexOf('zone') >= 0
      if $(this).text().indexOf('VE') >= 0
        $(this).next('.expand-section').addClass('zone-V')
      if $(this).text().indexOf('AE') >= 0
        $(this).next('.expand-section').addClass('zone-A')
      if $(this).text().indexOf('A') >= 0
        $(this).next('.expand-section').addClass('zone-A')
      if $(this).text().indexOf('AO') >= 0
        $(this).next('.expand-section').addClass('zone-A')
      if $(this).text().indexOf('X') >= 0
        $(this).next('.expand-section').addClass('zone-X')
      if $(this).text().indexOf('current') >= 0
        $(this).next('.expand-section').addClass('zone-current')
      if $(this).text().indexOf('not in a flood zone') >= 0
        $(this).next('.expand-section').addClass('zone-N').addClass('zone-current').addClass('zone-updated')
      if $(this).text().indexOf('updated') >= 0
        $(this).next('.expand-section').addClass('zone-updated')
      if $(this).text().indexOf('not') >= 0 && $(this).text().indexOf('changing') >= 0
        $(this).next('.expand-section').addClass('zone-no-change')


  $('#content').on 'click', '.expand', (event) ->
    $(event.currentTarget).toggleClass('open').find('.plus').toggle().end().next('.expand-section').slideToggle('fast')


  # Caution boxes
  $('#content').find('p,div,li').each () ->
    if $(this).text().indexOf('Caution:') == 0 || $(this).text().indexOf('CAUTION:') == 0
      $(this).addClass('box-caution').append('<a class="caution-close">OK</a>')
  $('#content').on 'click', '.caution-close', (event) ->
    $(event.currentTarget).closest('.box-caution').slideUp 'fast'


  # Address box (if we have a cookied flood zone)
  if $.cookie('address')
    # Add the box
    box = "<div id=\"current-zone-box\" class=\"box-current\">
      <p class=\"heading\"><strong>Your Results</strong></p>
      <p><span class=\"marker\"></span>#{$.cookie('address')}</p>
      <p class=\"half\"><strong>Flood Zone Today</strong> #{$.cookie('cFLD_ZONE')}</p>
      <p class=\"half\"><strong>Flood Zone 2016</strong> #{$.cookie('pFLD_ZONE')}</p>
      <p class=\"half\"><strong>BFE Today</strong> #{$.cookie('cSTATIC_BFE')}</p>
      <p class=\"half\"><strong>BFE 2016</strong> #{$.cookie('pSTATIC_BFE')}</p>
      <a class=\"close\"></a>
    </div>"
    $('#content .column-right').prepend box
    # Open any sections
    #console.log $.cookie('cFLD_ZONE');
    #console.log $.cookie('cSTATIC_BFE');
    #console.log $.cookie('pFLD_ZONE');
    #console.log $.cookie('pSTATIC_BFE');
    #$('.expand-section').filter("current-zone-#{$.cookie('cFLD_ZONE')}").slideDown('fast')
    #$('.expand-section').filter("new-zone-#{$.cookie('pFLD_ZONE')}").slideDown('fast')
    filterFor = ".zone-current.zone-#{$.cookie('cFLD_ZONE').charAt(0)}"
    if $.cookie('cFLD_ZONE') == $.cookie('pFLD_ZONE')
      filterFor += ',.zone-no-change'
    else
      filterFor += ",.zone-updated.zone-#{$.cookie('pFLD_ZONE').charAt(0)}"
    $('.expand-section').filter(filterFor).slideDown('fast').prev('.expand').addClass('open').find('.plus').toggle()
  console.log filterFor
  $('#current-zone-box').on 'click', '.close', () ->
    $('#current-zone-box').slideUp 'fast'


  # CYOA
  # - Function to save accumulated data, for the eventual email
  questionData = []
  saveAccumulatedData = () ->
    questionData = _.map $('#content .q.open'), (item) ->
      {
        question: $(item).children('.q-question').html()
        answer: $(item).children('.q-buttons').find('.selected').text()
      }
    #console.log questionData

  # - Do the question toggling of both sections
  $('#questions1').on 'click', '.q-button', (event) ->
    button = $(event.currentTarget)
    button.parent().siblings('.q').hide().removeClass('open')
    button.addClass('selected').siblings('.q-button').removeClass('selected')
    saveAccumulatedData()
    if button.data('q-to')
      $('#questions2').find('.q').hide()
      button.parent().siblings(".q-#{button.data('q-to')}").addClass('open').slideDown 'fast'
    else
      $('#questions2 .q:first-child').addClass('open').slideDown 'fast'

  $('#questions2').on 'click', '.q-button', (event) ->
    button = $(event.currentTarget)
    button.parent().siblings('.q').removeClass('open').hide()
    button.addClass('selected').siblings('.q-button').removeClass('selected')
    saveAccumulatedData()
    $('#questions2').find('.box-current').removeClass('box-current')
    selectedSection = button.parent().siblings(".q-#{button.data('q-to')}")
    selectedSection.addClass('open').slideDown 'fast'
    unless selectedSection.find('.q-buttons').length
      selectedSection.addClass('box-current')
      $('#cyoa-email').show()
      saveAccumulatedData()

