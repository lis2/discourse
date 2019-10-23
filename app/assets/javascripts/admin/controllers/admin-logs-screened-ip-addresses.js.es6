import Controller from "@ember/controller";
import debounce from "discourse/lib/debounce";
import { outputExportResult } from "discourse/lib/export-result";
import { exportEntity } from "discourse/lib/export-csv";
import ScreenedIpAddress from "admin/models/screened-ip-address";

export default Controller.extend({
  loading: false,
  filter: null,
  savedIpAddress: null,

  show: debounce(function() {
    this.set("loading", true);
    ScreenedIpAddress.findAll(this.filter).then(result => {
      this.setProperties({ model: result, loading: false });
    });
  }, 250).observes("filter"),

  actions: {
    allow(record) {
      record.set("action_name", "do_nothing");
      record.save();
    },

    block(record) {
      record.set("action_name", "block");
      record.save();
    },

    edit(record) {
      if (!record.get("editing")) {
        this.set("savedIpAddress", record.get("ip_address"));
      }
      record.set("editing", true);
    },

    cancel(record) {
      const savedIpAddress = this.savedIpAddress;
      if (savedIpAddress && record.get("editing")) {
        record.set("ip_address", savedIpAddress);
      }
      record.set("editing", false);
    },

    save(record) {
      const wasEditing = record.get("editing");
      record.set("editing", false);
      record
        .save()
        .then(() => this.set("savedIpAddress", null))
        .catch(e => {
          if (e.jqXHR.responseJSON && e.jqXHR.responseJSON.errors) {
            bootbox.alert(
              I18n.t("generic_error_with_reason", {
                error: e.jqXHR.responseJSON.errors.join(". ")
              })
            );
          } else {
            bootbox.alert(I18n.t("generic_error"));
          }
          if (wasEditing) record.set("editing", true);
        });
    },

    destroy(record) {
      return bootbox.confirm(
        I18n.t("admin.logs.screened_ips.delete_confirm", {
          ip_address: record.get("ip_address")
        }),
        I18n.t("no_value"),
        I18n.t("yes_value"),
        result => {
          if (result) {
            record
              .destroy()
              .then(deleted => {
                if (deleted) {
                  this.model.removeObject(record);
                } else {
                  bootbox.alert(I18n.t("generic_error"));
                }
              })
              .catch(e => {
                bootbox.alert(
                  I18n.t("generic_error_with_reason", {
                    error: `http: ${e.status} - ${e.body}`
                  })
                );
              });
          }
        }
      );
    },

    recordAdded(arg) {
      this.model.unshiftObject(arg);
    },

    rollUp() {
      return bootbox.confirm(
        I18n.t("admin.logs.screened_ips.roll_up_confirm"),
        I18n.t("no_value"),
        I18n.t("yes_value"),
        confirmed => {
          if (confirmed) {
            this.set("loading", true);
            return ScreenedIpAddress.rollUp().then(results => {
              if (results && results.subnets) {
                if (results.subnets.length > 0) {
                  this.send("show");
                  bootbox.alert(
                    I18n.t("admin.logs.screened_ips.rolled_up_some_subnets", {
                      subnets: results.subnets.join(", ")
                    })
                  );
                } else {
                  this.set("loading", false);
                  bootbox.alert(
                    I18n.t("admin.logs.screened_ips.rolled_up_no_subnet")
                  );
                }
              }
            });
          }
        }
      );
    },

    exportScreenedIpList() {
      exportEntity("screened_ip").then(outputExportResult);
    }
  }
});
