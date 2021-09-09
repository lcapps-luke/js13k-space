package ptcl;

import js.html.CanvasRenderingContext2D;
import math.Vec;

interface Ptcl{
	function update(s:Float):Void ;
	function draw(c:CanvasRenderingContext2D):Void;
	function getPosition():Vec;
	function getRadius():Float;
	function isAlive():Bool;
}