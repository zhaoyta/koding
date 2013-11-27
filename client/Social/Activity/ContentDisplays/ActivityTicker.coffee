class ActivityTicker extends JView
  constructor:(options={}, data)->
    options.cssClass      = "activity-right-block"

    super options, data

    @listController = new KDListViewController
      lazyLoadThreshold: .99
      viewOptions :
        type      : "activities"
        cssClass  : "activities"
        itemClass : ActivityTickerItem

    @listView = @listController.getView()

    @listController.on "LazyLoadThresholdReached", @bound "load"

    @load()

  load: ->
    options =
      limit : 20
      skip  : @listController.getItemCount() or 0

    KD.remote.api.ActivityTicker.fetch options, (err, items = []) =>
      @listController.hideLazyLoader()
      @listController.addItem item for item in items  unless err

  pistachio:
    """
    <div class="activity-ticker">
      <h3>Activity Feed <i class="cog-icon"></i></h3>
      {{> @listView}}
    </div>
    """
