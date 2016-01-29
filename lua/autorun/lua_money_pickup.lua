easylua.StartEntity("lua_money_pickup")

ENT.Author					= "Potatofactory, Flex"
ENT.PrintName 				= "Money"
ENT.Spawnable 				= false
ENT.AdminSpawnable 			= false
ENT.Value 					= 0

ENT.Configuration 			= {
	["defines"] = {
		["warn_negative"] = true,
		["low"]	= 100,
		["max_value"] = 1000,
		["sfxValueChanged"] = "vo/Citadel/br_laugh01.wav",
		["sfxPickupMoney"] = "vo/npc/female01/nice01.wav",
	},

	["models"] = {
		["low"] = "models/props/cs_assault/Dollar.mdl",
		["high"] = "models/props/cs_assault/Money.mdl",
	},

	["lighting"] = {
		["enabled"] = true,
		["colour"] = Color( 255, 255, 255 ),
		["sprite_max"] = 30,
		["sprite_decay"] = 15,
	},

}


if SERVER then
	function ENT:Initialize()
		self:SetModel( self.Configuration["models"]["low"] ) -- Temportary
		self:PhysicsInit( SOLID_BBOX )
		self:PhysWake()
	end

	function ENT:AssignValue( num )
		if num < 0 and self.Configuration["defines"]["warn_negative"] then
			self:SetColor( 255, 225, 225 )
			self.Configuration["lighting"]["colour"] = Color( 255, 220, 220 )
		end
		if num <= self.Configuration["defines"]["low"] then
			self:SetModel( self.Configuration["models"]["low"] )
		else
			if num > self.Configuration["defines"]["max_value"] then
				local entsneeded, extras = math.modf( num / self.Configuration["defines"]["max_value"] )
				if extras == 0 then
					for i=1, entsneeded - 1 do 
						local newmoney = ents.Create( self:GetClass() )
						newmoney:SetPos( self:GetPos() )
						newmoney:Spawn()
						newmoney:AssignValue( self.Configuration["defines"]["max_value"] )
					end
				else
					for i=1, entsneeded - 1 do 
						local newmoney = ents.Create( self:GetClass() )
						newmoney:SetPos( self:GetPos() )
						newmoney:Spawn()
						newmoney:AssignValue( self.Configuration["defines"]["max_value"] )
					end
					local floatmoney = ents.Create( self:GetClass() )
					floatmoney:SetPos( self:GetPos() )
					floatmoney:Spawn()
					floatmoney:AssignValue( math.floor( self.Configuration["defines"]["max_value"] * extras ) )
				end

				self:Remove() -- No longer needed
			else
				self:SetModel( self.Configuration["models"]["high"] )
			end
		end
		self.Value = num
		self:EmitSound( self.Configuration["defines"]["sfxValueChanged"] )
	end

	function ENT:Use( _, ply )
		if not ply:IsPlayer() then return end
		self:EmitSound( self.Configuration["defines"]["sfxPickupMoney"] )
		ply:GiveMoney( self.Value )
		self:Remove()
	end

end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()

		-- Things that help make the money 'distinguished'
		local mat = Matrix()
		mat:Scale( Vector( 1.5, 1.5, 1.5 ) )
		self:EnableMatrix( "RenderMultiply", mat )

		if self.Configuration["lighting"]["enabled"] then
			local dlight = DynamicLight( self:EntIndex() )
			if dlight then
				dlight.pos = self:GetPos() + Vector( 0, 0, 20 )
				dlight.r = self.Configuration["lighting"]["colour"].r
				dlight.g = self.Configuration["lighting"]["colour"].g
				dlight.b = self.Configuration["lighting"]["colour"].b
				dlight.brightness = 5
				dlight.Decay = self.Configuration["lighting"]["sprite_decay"]
				dlight.Size = self.Configuration["lighting"]["sprite_max"]
				dlight.DieTime = CurTime() + 1
			end
		end
	end
end

easylua.EndEntity(false, false)