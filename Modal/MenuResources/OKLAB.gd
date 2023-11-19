extends Node
class_name OKLAB

## Implementation of sRGB and OKLAB relationship.
## 
## Original found here: https://bottosson.github.io/posts/oklab/

## sRGB structure
class RGB:
	var r: float ## Redness
	var g: float ## Greenness 
	var b: float ## Blueness 
	
## OKLAB structure
class Lab: 
	var L: float ## Perceived lightness
	var a: float ## Green/Red
	var b: float ## Blue/Yellow
	
## OKLAB structure with similar controls to HSV
class PolarLab:
	var L: float ## Perceived lightness
	var C: float ## Chroma. C = sqrt(a^2 + b^2)
	var h: float ## Hue. h = atan2(b, a) 

## Converts sRGB colorspace into OKLAB colorspace.
func linear_srgb_to_oklab(c: RGB) -> Lab:
	
	var l: float = 0.4122214708 * c.r + 0.5363325363 * c.g + 0.0514459929 * c.b
	var m: float = 0.2119034982 * c.r + 0.6806995451 * c.g + 0.1073969566 * c.b
	var s: float = 0.0883024619 * c.r + 0.2817188376 * c.g + 0.6299787005 * c.b
	
	var l_: float = pow(l, 1.0/3.0)
	var m_: float = pow(m, 1.0/3.0)
	var s_: float = pow(s, 1.0/3.0)
	
	var out: Lab = Lab.new()
	
	out.L = 0.2104542553 * l_ + 0.7936177850 * m_ - 0.0040720468 * s_
	out.a = 1.9779984951 * l_ - 2.4285922050 * m_ + 0.4505937099 * s_
	out.b = 0.0259040371 * l_ + 0.7827717662 * m_ - 0.8086757660 * s_
	
	return out
	
## Converts OKLAB colorspace into sRGB colorspace.
func oklab_to_linear_srgb(c: Lab) -> RGB: 
	
	var l_: float = c.L + 0.3963377774 * c.a + 0.2158037573 * c.b
	var m_: float = c.L - 0.1055613458 * c.a - 0.0638541728 * c.b
	var s_: float = c.L - 0.0894841775 * c.a - 1.2914855480 * c.b
	
	var l: float = l_ * l_ * l_
	var m: float = m_ * m_ * m_
	var s: float = s_ * s_ * s_
	
	var out: RGB = RGB.new()
	
	out.r = +4.0767416621 * l - 3.3077115913 * m + 0.2309699292 * s
	out.g = -1.2684380046 * l + 2.6097574011 * m - 0.3413193965 * s
	out.b = -0.0041960863 * l - 0.7034186147 * m + 1.7076147010 * s
	
	return out
	
## Converts OKLAB standard coordinates to OKLAB polar coordinates.
func oklab_to_polar_oklab(c: Lab) -> PolarLab:
	
	var out: PolarLab = PolarLab.new()
	
	out.L = c.L
	out.C = sqrt(pow(c.a, 2) + pow(c.b, 2))
	out.h = atan2(c.b, c.a)
	
	return out
	
## Converts OKLAB polar coordinates to OKLAB standard coordinates.
func polar_oklab_to_oklab(c: PolarLab) -> Lab:
	
	var out: Lab = Lab.new()
	
	out.L = c.L
	out.a = c.C * cos(c.h)
	out.b = c.C * sin(c.h)
	
	return out
	
## Converts OKLAB colorspace in polar coordinates to sRGB colorspace.
func polar_oklab_to_linear_srgb(c: PolarLab) -> RGB:
	return oklab_to_linear_srgb(polar_oklab_to_oklab(c))
	
## Converts sRGB colorspace to OKLAB colorspace in polar coordinates.
func linear_srgb_to_polar_oklab(c: RGB) -> PolarLab:
	return oklab_to_polar_oklab(linear_srgb_to_oklab(c))
