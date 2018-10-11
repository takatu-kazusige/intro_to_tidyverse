# PDF図中で日本語を表示させる
setHook(
  packageEvent("grDevices", "onLoad"),
  function(...) {
    grDevices::pdf.options(family="Japan1GothicBBB")
  }
)
