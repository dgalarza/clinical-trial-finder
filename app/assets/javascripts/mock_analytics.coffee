@GoogleAnalyticsStub = (->
  {
    actions: []
    lastAction: ->
      _.last(@actions) || {}
  }
)()

@performance = {
  now: -> 1
}

@AnalyticsStub = (->
  {
    events: []
    identifies: []
    analytics_pages: []

    lastEvent: ->
      _.last(@events) || {}

    lastIdentify: ->
      _.last(@identifies) || {}

    lastPage: ->
      _.last(@analytics_pages) || {}
  }
)()

@analytics =
  alias: ->
  ready: (callback) ->
    @readyCallback = callback

  load: ->
    window.ga = (action, hitType, category, variable, value) ->
      @GoogleAnalyticsStub.actions.push(
        name: action,
        properties: {
          hitType: hitType,
          category: category,
          variable: variable,
          value: value,
        }
      )

    if typeof @readyCallback == "function"
      @readyCallback()

  identify: (userId, traits) ->
    AnalyticsStub.identifies.push(
      userId: userId,
      traits: traits
    )

  page: (eventName, properties) ->
    AnalyticsStub.analytics_pages.push(
      name: eventName,
      properties: properties
    )

  track: (eventName, properties) ->
    AnalyticsStub.events.push(
      name: eventName,
      properties: properties
    )
