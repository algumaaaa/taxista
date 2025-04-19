extends Node


static func reconnect(sig: Signal, cb: Callable, flags: int = 0) -> void:
	if sig.is_null():
		print_debug("Error: signal is null: ", sig)
		return
	if not cb.is_valid():
		print_debug("Error: Callback is invalid: ", cb )
		return
	if not sig.is_connected(cb):
		sig.connect(cb, flags)
