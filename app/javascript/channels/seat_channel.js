import consumer from "./consumer"

consumer.subscriptions.create({ channel: "SeatChannel" }, {
  received(data) {
    alert('Hi action cable')
  }  
})
