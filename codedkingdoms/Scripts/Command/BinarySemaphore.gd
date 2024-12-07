extends Node
class_name BinarySemaphore

var semaphore: Semaphore
var mutex: Mutex
var num_permits: int

func _init():
	num_permits = 0
	semaphore = Semaphore.new()
	mutex = Mutex.new()

func wait():
	mutex.lock()
	num_permits -= 1
	mutex.unlock()
	var _dump = semaphore.wait()

	
func post():
	mutex.lock()
	if num_permits == -1:
		num_permits += 1
		var _dump = semaphore.post()
	mutex.unlock()
