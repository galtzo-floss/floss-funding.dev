import { Controller } from "@hotwired/stimulus"

// A simple carousel that cycles through children and applies a slot-machine spin-in animation
export default class extends Controller {
  static targets = ["track"]
  static values = { interval: { type: Number, default: 10000 } }

  connect() {
    this.index = 0
    this.cards = Array.from(this.trackTarget.querySelectorAll('.slot-card'))
    if (this.cards.length <= 1) return

    // Ensure only the first is visible at start
    this.cards.forEach((el, i) => {
      el.style.opacity = i === 0 ? '1' : '0'
      if (i !== 0) el.classList.add('pointer-events-none')
    })

    this.start()
  }

  disconnect() {
    this.stop()
  }

  start() {
    this.stop()
    this.timer = setInterval(() => this.next(), this.intervalValue)
  }

  stop() {
    if (this.timer) {
      clearInterval(this.timer)
      this.timer = null
    }
  }

  next() {
    if (!this.cards || this.cards.length === 0) return
    const current = this.cards[this.index]
    this.index = (this.index + 1) % this.cards.length
    const next = this.cards[this.index]

    // Hide current
    current.style.opacity = '0'
    current.classList.add('pointer-events-none')

    // Prepare next animation
    next.classList.remove('pointer-events-none')
    next.style.opacity = '1'

    // Re-trigger animation by toggling the class
    next.classList.remove('slot-spin-in')
    // force reflow
    void next.offsetWidth
    next.classList.add('slot-spin-in')
  }
}
