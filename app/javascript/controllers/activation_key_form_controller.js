import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["ossFields"]

  connect() {
    this.toggleOss()
  }

  toggleOss() {
    const checkbox = this.element.querySelector('input[name="activation_key[free_for_open_source]"]')
    if (!checkbox) return
    if (checkbox.checked) {
      this.ossFieldsTarget.classList.remove('hidden')
    } else {
      this.ossFieldsTarget.classList.add('hidden')
    }
  }
}
