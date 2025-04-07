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

  changeClass(event) {
    let activeClass = "is-active";
    let selectedItem = event.target.parentElement;
    let menuTabs = document.querySelectorAll(".menu-tabs");

    menuTabs.forEach((element) => {
      if (element !== selectedItem) {
        element.classList.remove(activeClass);
      } else {
        element.classList.add(activeClass);
      }
    });
  }
}
