ActivitiesConstants = require '../constants/activities_constants'

ActivitiesActionCreators = Marty.createActionCreators
  id: 'ActivitiesActionCreators'

  edit: (activity)->
    @dispatch ActivitiesConstants.ACTIVITY_EDIT, activity

  update: (activity)->
    @dispatch ActivitiesConstants.ACTIVITY_UPDATE, activity


module.exports = ActivitiesActionCreators