-- RETURN USER-CREATED ANIMATION GROUPS.

-- Format:    key       = <start_tile> (tilesource number)
--            { value } = <end_tile>   (tilesource number)
--                        <playback>   (animation style)
--                        <step>       (frame duration in seconds)

-- Playbacks: "loop_forward"
--            "loop_backward"
--            "loop_pingpong"
--            "loop_corolla"
--            "once_forward"
--            "once_backward"
--            "once_pingpong"
--            "once_corolla"

return {
	[1]  = { end_tile = 9,  playback = "loop_forward",  step = 0.55  },
	[11] = { end_tile = 19, playback = "loop_backward", step = 0.55  },
	[21] = { end_tile = 29, playback = "loop_pingpong", step = 0.75  },
	[31] = { end_tile = 39, playback = "loop_corolla",  step = 0.75  },
	[41] = { end_tile = 49, playback = "once_forward",  step = 0.35  },
	[51] = { end_tile = 59, playback = "once_backward", step = 0.35  },
	[61] = { end_tile = 69, playback = "once_pingpong", step = 0.35  },
	[71] = { end_tile = 79, playback = "once_corolla",  step = 0.35  }
}