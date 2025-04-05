import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="file-upload"
export default class extends Controller {
  static targets = ["fileName"];
  connect() {}

  updateFileName(event) {
    let uploadedFile = [...event.target.files][0].name;
    this.fileNameTarget.textContent = ` ${uploadedFile} `;
  }
}
