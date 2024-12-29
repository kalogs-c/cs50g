local StateMachine = require("state_machine")
local StartState = require("states.start_state")
local ServeState = require("states.serve_state")
local PlayState = require("states.play_state")
local VictoryState = require("states.victory_state")
local GameOverState = require("states.gameover_state")
local quads = require("quads")

G = {}

G.WINDOW = {
	TITLE = "Breakout",
	WIDTH = 1280,
	HEIGHT = 720,
	VIRTUAL = {
		WIDTH = 432,
		HEIGHT = 243,
	},
}

G.FONTS = {
	SMALL = love.graphics.newFont("assets/fonts/font.ttf", 8),
	MEDIUM = love.graphics.newFont("assets/fonts/font.ttf", 16),
	LARGE = love.graphics.newFont("assets/fonts/font.ttf", 32),
}

G.TEXTURES = {
	BACKGROUND = love.graphics.newImage("assets/graphics/background.png"),
	BREAKOUT = love.graphics.newImage("assets/graphics/breakout.png"),
	ARROWS = love.graphics.newImage("assets/graphics/arrows.png"),
	HEARTS = love.graphics.newImage("assets/graphics/hearts.png"),
	PARTICLES = love.graphics.newImage("assets/graphics/particle.png"),
}

G.FRAMES = {
	PADDLES = quads.generate_paddles_quads(G.TEXTURES.BREAKOUT),
	BALLS = quads.generate_balls_quads(G.TEXTURES.BREAKOUT),
	BRICKS = quads.generate_bricks_quads(G.TEXTURES.BREAKOUT),
	HEARTS = quads.generate_quads(G.TEXTURES.HEARTS, 10, 9),
}

G.SOUNDS = {
	PADDLE_HIT = love.audio.newSource("assets/sounds/paddle_hit.wav", "static"),
	SCORE = love.audio.newSource("assets/sounds/score.wav", "static"),
	WALL_HIT = love.audio.newSource("assets/sounds/wall_hit.wav", "static"),
	CONFIRM = love.audio.newSource("assets/sounds/confirm.wav", "static"),
	SELECT = love.audio.newSource("assets/sounds/select.wav", "static"),
	NO_SELECT = love.audio.newSource("assets/sounds/no-select.wav", "static"),
	BRICK_HIT1 = love.audio.newSource("assets/sounds/brick-hit-1.wav", "static"),
	BRICK_HIT2 = love.audio.newSource("assets/sounds/brick-hit-2.wav", "static"),
	HURT = love.audio.newSource("assets/sounds/hurt.wav", "static"),
	VICTORY = love.audio.newSource("assets/sounds/victory.wav", "static"),
	RECOVER = love.audio.newSource("assets/sounds/recover.wav", "static"),
	HIGH_SCORE = love.audio.newSource("assets/sounds/high_score.wav", "static"),
	PAUSE = love.audio.newSource("assets/sounds/pause.wav", "static"),
	MUSIC = love.audio.newSource("assets/sounds/music.wav", "static"),
}

G.CONSTANTS = {
	PADDLE_SPEED = 200,
}

G.StateMachine = StateMachine.new({
	["start"] = StartState.new,
	["serve"] = ServeState.new,
	["play"] = PlayState.new,
	["gameover"] = GameOverState.new,
	["victory"] = VictoryState.new,
})
