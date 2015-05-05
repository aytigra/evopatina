ActivitiesConstants = require '../constants/activities_constants'

ActivitiesActionCreators = Marty.createActionCreators
  id: 'ActivitiesActionCreators'

  edit: (activity)->
    @dispatch ActivitiesConstants.ACTIVITY_EDIT, activity
  cancel: (activity)->
    @dispatch ActivitiesConstants.ACTIVITY_CANCEL, activity
  update: (activity)->
    @dispatch ActivitiesConstants.ACTIVITY_UPDATE, activity
  update_response: (activity, ok)->
    @dispatch ActivitiesConstants.ACTIVITY_UPDATE_RESPONSE, activity, ok
  save: (activity)->
    @dispatch ActivitiesConstants.ACTIVITY_SAVE, activity
  destroy: (activity)->
    @dispatch ActivitiesConstants.ACTIVITY_DELETE, activity
  create: (subsector_id)->
    @dispatch ActivitiesConstants.ACTIVITY_CREATE, subsector_id
  create_response: (activity, ok)->
    @dispatch ActivitiesConstants.ACTIVITY_CREATE_RESPONSE, activity, ok

module.exports = ActivitiesActionCreators