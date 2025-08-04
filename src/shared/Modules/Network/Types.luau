export type Net = {
	__index: Net,
	new: (string) -> NetWork?,
	NetWorks: { [string]: NetWork },
	Update: RemoteEvent,
	--Adds a new remote
	AddRE: (NetWork, string) -> (RemoteEvent?, Event?),
	GetNetwork: (Net, string) -> NetWork,
	GetRE: (NetWork, string) -> Event | Event,
	Types: {},
}

export type NetWork = typeof(setmetatable(
	{} :: { ServerEvents: { [string]: Event }, ClientEvents: { [string]: Event }, Name: string },
	{} :: Net
))

export type EventModule = {
	__index: EventModule,
	new: (RemoteEvent) -> Event,
	Fire: (Event, Player, ...any) -> (),
	Connect: (Event, (...any) -> ...any) -> (() -> ())?,
	Once: (Event, (...any) -> ...any) -> (() -> ())?,
	Destroy: (Event) -> (),
	FireAll: (Event, ...any) -> (),
}

export type Event = typeof(setmetatable(
	{} :: { Event: RemoteEvent, Connections: { (...any) -> ...any } },
	{} :: EventModule
))

return {}
