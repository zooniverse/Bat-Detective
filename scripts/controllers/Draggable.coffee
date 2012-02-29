Spine = require 'Spine'

Draggable = new Spine.Module
	onMouseDown: (e) -> e.preventDefault(); @mouseDown = e;
	onMouseMove: (e) -> @onDrag e if @mouseDown
	onMouseUp: (e) -> delete @mouseDown
