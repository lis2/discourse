import Controller from "@ember/controller";
export default Controller.extend({
  router: Ember.inject.service(),
  queryParams: ["category_id"]
});
