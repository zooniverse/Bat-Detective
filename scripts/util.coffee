exports =
	delay: (duration, callback) ->
		if typeof duration is 'function'
			callback = duration
			duration = 0

		setTimeout callback, duration

	limit: (n, min = 0, max = 1) ->
		Math.min Math.max(min, n), max
