import { Controller } from "@hotwired/stimulus"

// Controls the mobile navigation menu toggle
export default class extends Controller {
  static targets = ["menu", "openIcon", "closeIcon"]

  connect() {
    // Ensure initial state is collapsed
    this.close()
  }

  toggle(event) {
    event?.preventDefault?.()
    const isHidden = this.menuTarget.classList.contains("hidden")
    if (isHidden) {
      this.open()
    } else {
      this.close()
    }
  }

  get toggleButton() {
    return this.element.querySelector('[aria-controls="mobile-nav"]')
  }

  open() {
    this.menuTarget.classList.remove("hidden")
    // Swap icons
    if (this.hasOpenIconTarget) this.openIconTarget.classList.add("hidden")
    if (this.hasCloseIconTarget) this.closeIconTarget.classList.remove("hidden")
    // Update ARIA
    this.toggleButton?.setAttribute("aria-expanded", "true")
  }

  close() {
    this.menuTarget.classList.add("hidden")
    // Swap icons
    if (this.hasOpenIconTarget) this.openIconTarget.classList.remove("hidden")
    if (this.hasCloseIconTarget) this.closeIconTarget.classList.add("hidden")
    // Update ARIA
    this.toggleButton?.setAttribute("aria-expanded", "false")
  }
}
