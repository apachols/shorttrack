angular.module("profile", ["ngResource"])
  .controller "ProfileController", [
    "$scope", "$resource",
    ( $scope, $resource ) ->
      console.log "ALOE GUVNAH"
  ]