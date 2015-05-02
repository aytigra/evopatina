ActivitiesConstants = require '../constants/activities_constants'

ActivitiesActionCreators = Marty.createActionCreators
  id: 'ActivitiesActionCreators'

  edit: (activity)->
    @dispatch ActivitiesConstants.ACTIVITY_EDIT, activity


module.exports = ActivitiesActionCreators