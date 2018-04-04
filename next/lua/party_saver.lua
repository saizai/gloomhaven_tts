-- Party Saver v. 1 (2018-03-29) by Sai
-- based on SkyTools v.171223a

-- Imporant bits:
-- 1. The tool will save & stage all items that
-- a) are in the following scripting zones:
save_zones = {"5f30df", "ffb741"}
	-- set the above to the GUIDs of your scripting zones
	-- zone tool > scripting > right click on zone to get its GUID
-- b) and are NOT in the Sky Tools "Ignore Me" tool.

-- 2. Bag names have to be prefixed with Party_ (rather than SET_)



-- Reverse-engineering documentation (by Sai)

-- The staged bag has a Lua script set on it that encodes position & rotation, like so (e.g.):
--guid,	position x, y, z,	rotation x, y, z
--eaab42,-25.375,1.70004177093506,4.54663324356079,-0.000264307513134554,179.971252441406,-0.000768354104366153
--846c64,-31.0625019073486,1.98861384391785,-0.757773697376251,359.991485595703,240.017440795898,-0.00146745936945081
--66b109,-25.8026428222656,2.35217499732971,-0.744665682315826,0.00652658706530929,90.0387268066406,359.992645263672

-- GUIDs hard coded:
-- 81d168	Ignore Me list
-- c80408	Toggle Ignore tool
-- 2d647a	Stage tool
-- 649822	SkyTools Board Hider
-- 059864	Panel III
-- 3761d8	Panel II
-- ff9bc3	Panel IV
-- 2deca3	Panel I

-- Values hard coded:
-- |44|, |26|, |26| - X, Y, Z boundaries of area operated on for storage purposes. Does not appear to account for varying table sizes. :(
-- |44|, |26|, |15| - bounds for deletion purposes. This is a bug, but probably rarely encountered since height >|15| is unlikely

-- Strings recognized (prefix if *):
-- SET_*	Bag containing a set
-- SBx_*	Table art

-- Variables:
-- global
-- i_M	The Toggle Ignore tool sets this global variable to the GUID of the Ignore Me object.
-- hld	Mutex to prevent concurrent operations

-- local on another object
-- tT_iM = "IgNor_mE"	The "Ignore Me" object sets this variable to identify itself. It's followed by commented GUIDs.

--	locals
--	var	renamed	description
--	aoj	all_objects	array of all objects
--	bb	objects_to_destroy	Queue of objects to destroy
--	sid		GUID of table art
--	cb	callback
--	sb	party_bag	GUID of the spawned bag
--	uls		GUIDs of named items found with pop

-- Functions
-- benDare	Set up the Ignore Me list into global i_M

original_guid = "b474b2"
callback = "imCopy" -- initial callback to selfdestruct if not the original GUID
ss = ""
party_bag = ""
objects_to_destroy = nil
prs = ""
sod = {}
zz = 0
z2 = 0
-- uls = ""
crlf = string.char(13)..string.char(10)


function onLoad()
-- removed delete and lock buttons
	local btn = {}
	btn.function_owner = self
	btn.font_size = 50

	btn.click_function = "btnBag"
	btn.label = "Save Party"
	btn.position = {1.62, -0.05, 0.67}
	btn.rotation = {0, 0, 0}
	btn.width = 285
	btn.height = 370
	self.createButton(btn)

	btn.click_function = "btnGetSod"
	btn.position = {0, -0.05, -0.91}
	btn.rotation = {0, 0, 0}
	btn.width = 300
	btn.height = 300
	btn.label = "Load Party"
	self.createButton(btn)

	Global.setVar("hld", 0)
end

function update()
	if callback then
		self.call(callback)
	end
end

-- Self-destruct if it doesn't have the original GUID
function imCopy()
	if zz > 5 then
		callback = nil
		if self.guid != original_guid then
			broadcastToAll("Party Saver & Stager copies will not work. Save the original directly to your TTS Saved Objects Chest!", {0.943, 0.745, 0.14})
			self.destruct()
		end
	end
	zz = zz+1
end

function btnBag()
	if callback or Global.getVar("hld") != 0 then -- abort on mutex or pending callback
		broadcastToAll("The Current Set is Busy...", {0.943, 0.745, 0.14})
		do return end
	end
	Global.setVar("hld", 1) -- set mutex

	ss = ""
	prs = ""
	local obj_guid
	local p
	local ignore_guids = ""
	if getObjectFromGUID(Global.getVar("i_M")) then
		ignore_guids = getObjectFromGUID(Global.getVar("i_M")).getLuaScript() -- contains GUIDs to ignore
	end

	local key = ""
	local obj = ""
	local i = 1
	local current_save_zone = save_zones[i]
	while current_save_zone do
		local zoneObjects = getObjectFromGUID(zoneGUID).getObjects()
		-- store it
		for key, obj in pairs(zoneObjects) do
			p = obj.getPosition()
			obj_guid = obj.getGUID()
			if not string.find(ignore_guids, obj.guid) then
				local r = obj.getRotation()
				ss = ss..obj_guid
				-- Sets the saved state.
				-- p = position {x, y, z}
				-- r = rotation {x, y, z}
				prs = prs.."--"..obj_guid..","..p[1]..","..p[2]..","..p[3]..","..r[1]..","..r[2]..","..r[3]..crlf
			end
		end
		i = i+1
		current_save_zone = save_zones[i]
	end

	if ss != "" then
		local saved_bag = {}
		saved_bag.type = "Bag"
		saved_bag.callback_owner = self
		saved_bag.callback = "cbBag"
		saved_bag.position = {70, 67, 70} -- temporary position that's out of the way
		spawnObject(saved_bag)
		if objects_to_destroy then
			getObjectFromGUID(objects_to_destroy).destruct()
			objects_to_destroy = nil
		end
	else
		Global.setVar("hld", 0)
	end
end

function cbBag(o)
	o.setLuaScript(prs)
	o.setName("PARTY_")
	o.lock()
	o.setScale({15, 1, 15})
	o.setRotation({0, 0, 0})
	o.setPosition({70, 98, 70})
	party_bag = o.getGUID()
	zz = 2
	z2 = 0
	prs = ""
	callback = "cbStowAway"
end

function hmBag()
	local s = self.getScale()
	s = s[1]*2+1.5
	local r = self.getRotation()
	r[2] = r[2]+270
	if r[2] > 360 then
		r[2] = r[2]-360
	end
	local x = math.sin(math.rad(r[2]))*s
	local y = x/math.tan(math.rad(r[2]))
	getObjectFromGUID(party_bag).setRotation({0, r[2], 0})
	getObjectFromGUID(party_bag).setScale({1, 1, 1})
	local p = self.getPosition()
	getObjectFromGUID(party_bag).setPosition({p[1]-y, 0.823, p[3]+x})
	getObjectFromGUID(party_bag).unlock()  party_bag = ""
end

function table.contains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

function getObjectsInSaveZones()
	local key = ""
	local obj = ""
	local i = 1
	local current_save_zone = save_zones[i]
	local all_zone_objects = {}

	while current_save_zone do
		local zone_objects = getObjectFromGUID(zoneGUID).getObjects()
		-- store it
		for key, obj in pairs(zoneObjects) do
			table.insert(all_zone_objects, obj)
		end
		i = i+1
		current_save_zone = save_zones[i]
	end
	return all_zone_objects
end

function getGUIDsOfObjectsInSaveZones()
	local guids = {}
	local key = ""
	local obj = ""
	for key, obj in pairs(zoneObjects) do
		table.insert(guids, obj.guid)
	end
	return guids
end

function cbStowAway()
	local g
	zz = zz+1
	if zz > 1 then
		zz = 0
		g = string.sub(ss, 1, 6)
		ss = string.sub(ss, 7)
		prs = prs..g
		if getObjectFromGUID(g) then
			local s = getObjectFromGUID(g).getScale()
			getObjectFromGUID(g).setScale({0.1, 0.2, 0.3})
			getObjectFromGUID(g).setScale(s)
			getObjectFromGUID(g).setPosition({70, 100+z2*0, 70})
			getObjectFromGUID(party_bag).putObject(getObjectFromGUID(g))
		end
		if ss == "" then
			z2 = z2+1  if z2 > 3 and z2 < 9 then
				broadcastToAll("Pass "..z2-2, {0.943, 0.745, 0.14})
			end
			if z2 > 8 then
				callback = nil
				broadcastToAll("Manually add "..(string.len(prs)/6).." objects to Bag.", {0.943, 0.745, 0.14})
				for zz = 1, string.len(prs), 6 do
					g = string.sub(prs, zz, zz+5)
					getObjectFromGUID(g).setPosition({0, 2+zz/3, 0})
					getObjectFromGUID(g).setPositionSmooth({0, 2.3+zz/3, 0})
				end
				prs = ""
				Global.setVar("hld", 0)
				--hmBag()
				getObjectFromGUID(party_bag).setScale({1, 1, 1})
				getObjectFromGUID(party_bag).setPosition({0, 0.823, 0})
				getObjectFromGUID(party_bag).unlock()
				party_bag = ""
			else
				zz = 0
				callback = "endStowAway"
			end
		end
	end
end

function endStowAway()
	zz = zz+1
	if zz > 48 then
		ss = prs
		prs = ""
		callback = "cbStowAway"
		do return end
	end
	local i
	for i = 1, string.len(prs), 6 do
		if not getObjectFromGUID(string.sub(prs, i, i+5)) then
			prs = string.sub(prs, 1, i-1)..string.sub(prs, i+6)
		end
	end
	if prs == "" then
		callback = nill
		Global.setVar("hld", 0)
		hmBag()
	end
end


function btnTrash()
	if callback or Global.getVar("hld") != 0 then
		broadcastToAll("The Current Set is Busy...", {0.943, 0.745, 0.14})
		do return end
	end
	if objects_to_destroy then
		local s = getObjectFromGUID(objects_to_destroy).getLuaScript()
		local key = ""
		local obj = ""
		local i = 1
		local current_save_zone = save_zones[i]
		local all_zone_object_guids = getGUIDsOfObjectsInSaveZones()
		-- add crlf to end
		if string.sub(s, string.len(s)-1) != crlf then
			s = s..crlf
		end
		while s != "" do
			-- get next GUID in the stored script
			obj = getObjectFromGUID(string.sub(s, 3, 8))
			if obj then
				if table.contains(all_zone_object_guids, s) then
					obj.destruct()
				end
			end
			s = string.sub(s, string.find(s, crlf)+2)
		end
		getObjectFromGUID(objects_to_destroy).destruct()
		objects_to_destroy = nil
		btnGetSod()
	end
end

function onCollisionEnter(c)
	if  string.sub(c.collision_object.getName(), 1, 6) == "PARTY_" and c.collision_object.name == "Bag" then
		if callback or Global.getVar("hld") != 0 then
			broadcastToAll("The Current Set is Busy...", {0.943, 0.745, 0.14})
			do return end
		end
		local v = {}
		v = c.collision_object.getObjects()
		local x  local y  local z  local ct = 1  local n  local p  ss = ""
		prs = c.collision_object.getLuaScript()
		btnTrash()
		btnGetSod()
		Global.setVar("hld", 1)
		p = self.getPosition()
		while v[ct] do
			if getObjectFromGUID(v[ct].guid) and zz != 0.02 then
				zz = 0.02
				Global.setVar("hld", 0)
				c.collision_object.setPosition({p[1], p[2]+0.6, p[3]})
				c.collision_object.setPositionSmooth({p[1], p[2]+0.3, p[3]})
				do return end
			end
			ct = ct+1
		end
		ct = 1
		while v[ct] do
			if getObjectFromGUID(v[ct].guid) then
				broadcastToAll("Duplicate Object: "..v[ct].guid, {0.943, 0.745, 0.14})
				Global.setVar("hld", 0)
				upWeGo(v[ct].guid)
				do return end
			end
			ct = ct+1
		end
		ct = 1
		zz = 0
		objects_to_destroy = c.collision_object.getGUID()
		c.collision_object.lock()
		c.collision_object.setName("tras_h")
		c.collision_object.setScale({0, 0, 0})
		c.collision_object.setPosition({90, 90, 90})
		prs = string.gsub(prs, crlf, string.char(44))
		if string.sub(prs, string.len(prs)) != "," then
			prs = prs..","
		end
		while v[ct] do
			local t = {}
			t.guid = v[ct].guid
			t.position = {0, ct*2, 0}
			n = string.find(prs, "-"..v[ct].guid)
			if n then
				n = n+8
				zz = zz+1
				x, n = snipIt({n})  y, n = snipIt({n})  z, n = snipIt({n})  t.position = {x-70, y+70, z-70}
				x, n = snipIt({n})  y, n = snipIt({n})  z, n = snipIt({n})  t.rotation = {x, y, z}
				t.callback = "setStage"
				t.callback_owner = self
			end
			t.smooth = false
			c.collision_object.takeObject(t)
			ct = ct+1
		end
	end
end

function snipIt(a)
	local e = string.find(prs, string.char(44), a[1])
	return string.sub(prs, a[1], e-1), e+1
end

function setSod()
	if getObjectFromGUID(sid) then
	local p = getObjectFromGUID(sid).getPosition()
	local r = getObjectFromGUID(sid).getRotation()
	getObjectFromGUID(sid).setPosition({0, 0.91, 0})
	getObjectFromGUID(sid).setRotation(sod)
	if math.abs(p[1]) < 0.0005 and math.abs(p[2]-0.91) < 0.0005 and math.abs(p[3]) < 0.0005 and math.abs(sod[1]-r[1]) < 0.0005
		and math.abs(sod[2]-r[2]) < 0.0005 and math.abs(sod[3]-r[3]) < 0.0005 and getObjectFromGUID(sid).resting then
		callback = nil
	else
		zz = zz+1
		if zz > 20 then
		callback = nil
		print("Failed Alignment.")
		end
	end
	else
	sid = nil
	callback = nil
	end
end

function btnGetSod()
	if sid then -- table background setup
		if getObjectFromGUID(sid) then
			local s = self.getScale()
			s = s[1]*2+2
			local p = self.getPosition()
			local r = self.getRotation()
			if r[2] == 0 then r[2] = 360 end
			local x = math.sin(math.rad(r[2]))*s
			local y = x/math.tan(math.rad(r[2]))
			r[2] = r[2]+90
			getObjectFromGUID(sid).setScale({0.3, 0.3, 0.3})
			getObjectFromGUID(sid).setRotation({0, r[2], 0})
			getObjectFromGUID(sid).tooltip = true
			getObjectFromGUID(sid).interactable = true
			getObjectFromGUID(sid).unlock()
			getObjectFromGUID(sid).setPosition({p[1]-y, 2.2, p[3]+x})
			getObjectFromGUID(sid).setPositionSmooth({p[1]-y, 2.5, p[3]+x})
		end
		sid = nil
	end
end

function setStage(a)
	a.resting = true
	a.lock()
	local n = string.find(prs, "-"..a.guid)+8
	zz = zz-1
	y, n = snipIt({n})  z, n = snipIt({n})  x, n = snipIt({n})  a.setPosition({y, z, x})
	y, n = snipIt({n})  z, n = snipIt({n})  x, n = snipIt({n})  a.setRotation({y, z, x})
	ss = ss..(a.guid)
	if zz == 0 then
		callback = "popSetQ"
	end
end

function popSetQ()
	zz = zz+1
	if zz > 5 then
		zz = 0
		z2 = 0
		-- uls = ""
		callback = "popSet"
	end
end

function popSet()
	if ss == "" then
		callback = nil
		popSetZ()
		do return end
	end
	local x  local y  local z  local a  local b  local c  local n  local g  local p  local r
	g = string.sub(ss, 1, 6)
	n = string.find(prs, "-"..g)+8
	if not getObjectFromGUID(g) then
		ss = string.sub(ss, 7)
		broadcastToAll("Missing Object: "..g, {0.943, 0.745, 0.14})
		do return end
	end
	y, n = snipIt({n})
	z, n = snipIt({n})
	x, n = snipIt({n})
	p = getObjectFromGUID(g).getPosition()
	a, n = snipIt({n})
	b, n = snipIt({n})
	c, n = snipIt({n})
	r = getObjectFromGUID(g).getRotation()
	if getObjectFromGUID(g).resting then
		if math.abs(p[1]-y) < 0.0005 and math.abs(p[2]-z) < 0.0005 and math.abs(p[3]-x) < 0.0005 and
			math.abs(r[1]-a) < 0.0005 and math.abs(r[2]-b) < 0.0005 and math.abs(r[3]-c) < 0.0005 then
			z2 = z2+1
			if z2 > 9 then
				zz = 0
			end
		else zz = zz+1
			getObjectFromGUID(g).setRotation({a, b, c})
			getObjectFromGUID(g).setPosition({y, z, x})
			getObjectFromGUID(g).resting = true
		end
	else
		getObjectFromGUID(g).resting = true
		zz = zz+1
	end
	if zz > 99 then
		print("Failed Alignment.")
		zz = 0
	end
	if zz == 0 then
		ss = string.sub(ss, 7)
		z2 = 0
		-- if getObjectFromGUID(g).getName() != "" then
		-- 	uls = uls..g
		-- end
	end
end

function popSetZ()
	Global.setVar("hld", 0)
	broadcastToAll("Done...", {0.943, 0.745, 0.14})
end


-- function btnUnlock()
-- 	if callback or Global.getVar("hld") != 0 then
-- 		broadcastToAll("The Current Set is Busy...", {0.943, 0.745, 0.14})
-- 		do return end
-- 	end
-- 	local g  local i
-- 	print("Unlocking Named Set Objects...")
-- 	for i = 1, string.len(uls), 6 do
-- 		g = string.sub(uls, i, i+5)
-- 		if getObjectFromGUID(g) then
-- 			getObjectFromGUID(g).unlock()
-- 		end
-- 	end
-- end

function upWeGo(a)
	local p = getObjectFromGUID(a).getPosition()
	getObjectFromGUID(a).setPositionSmooth({p[1], p[2]+3, p[3]})
end





--tt
