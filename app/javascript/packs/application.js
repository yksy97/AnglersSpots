import Rails from "@rails/ujs"
// import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

// bootstrap導入
import "jquery";
import "popper.js";
import "bootstrap";
import "../stylesheets/application"; 

require("@nathanvda/cocoon")

Rails.start()
// JSとの競合を考慮してTurbolinksをきりました。
// Turbolinks.start()
ActiveStorage.start()