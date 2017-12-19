class @StatsPage
  constructor: (@options = {}) ->
    $(document).on 'turbolinks:load', =>
      @setupEventListeners()
      @setupCharts()
      $('.stats-search-bar').focus()

  setupEventListeners: =>
    $('.toggle-card-button').click (e) =>
      @toggleDropdown(e.currentTarget)
      $(e.currentTarget).siblings('.transaction-list').toggleClass('is-hidden')

    $('.toggle-transaction-group').click (e) =>
      @toggleDropdown(e.currentTarget)
      $(e.currentTarget).parents('.box').next('.transactions-list').toggleClass('is-hidden')

    $('.stats-search-bar').keyup (e) =>
      regex = new RegExp("^[a-zA-Z0-9 ]+$")
      str = String.fromCharCode(e.which)
      return unless regex.test(str)

      searchString = e.currentTarget.value.toLowerCase().trim()

      if searchString.length > 0
        $('.transactions-list-button-container').addClass 'is-hidden'
        $('.transactions-list').removeClass 'is-hidden'

        for element in $('.item-card')
          if $(element).find('.item-name').text().trim().toLowerCase().indexOf(searchString) > -1
            $(element).removeClass 'is-hidden'
            $(element).find('.transaction-list').removeClass 'is-hidden'
          else
            $(element).addClass 'is-hidden'

      else
        $('.transactions-list-button-container').removeClass 'is-hidden'
        $('.item-card').removeClass 'is-hidden'
        $('.transactions-list').addClass 'is-hidden'
        $('.transaction-list').addClass 'is-hidden'

  toggleDropdown: (target) ->
    if $(target).find('i.material-icons').text() == 'keyboard_arrow_right'
      $(target).find('i.material-icons').text('keyboard_arrow_down')
    else
      $(target).find('i.material-icons').text('keyboard_arrow_right')

  setupCharts: =>
    options = {
      responsive: true,
      legend: {
        display: false
      }
      scales: {
        yAxes: [{
                  ticks: {
                    min: 0
                  },
                  scaleLabel: {
                    display: true,
                    labelString: 'Price per Unit',
                    fontSize: 14,
                    fontColor: '#000'
                  }
                }],
        xAxes: [{
                  type: 'time',
                  display: true,
                }]
      }
    }

    $('.price-chart').each (i, element) =>
      data = []

      $(element).parents('.box').find('tbody').find('tr').each (i, el) ->
        cells = $(el).find('td')

        price = undefined
        price = $(cells[4]).text().trim().replace(/\/kg/,'').replace(/\$/,'')
        price = undefined if price == 'N/A'

        data.push {
          t: $(cells[0]).text().trim(),
          y: price,
        }

      data.sort (a, b) ->
        keyA = new Date(a.t)
        keyB = new Date(b.t)

        # // Compare the 2 dates
        return -1 if keyA < keyB
        return 1 if keyA > keyB
        return 0

      config = {
        type: 'line',
        data: {
          datasets: [{
            data: data,
            backgroundColor: 'transparent',
            borderColor: $(element).parents('.transactions-list').css('border-color')
          }]
        },
        options: options
      }

      new Chart element, config