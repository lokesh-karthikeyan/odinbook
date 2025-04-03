import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="toggler"
export default class extends Controller {
  static classes = ["toggle"];

  connect() {}

  toggle() {
    let menuItem = document.getElementById("navbarBasicExample");
    this.element.classList.toggle(this.toggleClass);
    menuItem.classList.toggle(this.toggleClass);
  }
}
