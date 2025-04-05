import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="flash"
export default class extends Controller {
  connect() {}

  dismiss(event) {
    let notification = event.target.closest(".flash.notification");
    notification.remove();
  }
}
