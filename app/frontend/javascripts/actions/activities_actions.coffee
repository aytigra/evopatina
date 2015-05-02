ActivitiesConstants = require '../constants/activities_constants'

ActivitiesActionCreators = Marty.createActionCreators
  id: 'ActivitiesActionCreators'

  edit: (activity)->
    @dispatch ActivitiesConstants.ACTIVITY_EDIT, activity
  cancel: (activity)->
    @dispatch ActivitiesConstants.ACTIVITY_CANCEL, activity
  update: (activity)->
    @dispatch ActivitiesConstants.ACTIVITY_UPDATE, activity
  save: (activity)->
    @dispatch ActivitiesConstants.ACTIVITY_SAVE, activity
  destroy: (activity)->
    @dispatch ActivitiesConstants.ACTIVITY_DELETE, activity

module.exports = ActivitiesActionCreators