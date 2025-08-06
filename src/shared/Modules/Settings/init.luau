local Settings = {}

Settings.Character = table.freeze(require(script.Character)) :: { { Name: string, Audio: number, id: number } }
Settings.Robux = table.freeze(require(script.RobuxSettings))

return Settings
