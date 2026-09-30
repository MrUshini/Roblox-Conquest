export type TGroupData = {model: Model}

export type TEntries = {
    [number]: TGroupData
}

local BattlegroupRegistry = {}

local entries = {} :: TEntries

function BattlegroupRegistry:Register(id: number, model: Model) : ()
    entries[id] = {model=model}
end

function BattlegroupRegistry:Remove(id: number) : ()
    entries[id] = nil
end

function BattlegroupRegistry:GetGroupData(id: number) : TGroupData?
    return entries[id]
end

function BattlegroupRegistry:GetGroupModel(id: number) : Model?
    local groupData = entries[id]
    if not groupData then
        print("Group data couldnt be found")
        return
    end
    return groupData.model
end

return BattlegroupRegistry