local ClientState = {}

-- TODO: ADD MULTIPLE GROUPS SELECTED STIMULTANIOUSLY

ClientState.SelectedBattlegroupId = nil :: number? -- Battlegroup ID
ClientState.SelectedUnitId = nil :: number? -- Unit ID (In the battlegroup)

function ClientState:ClearStates() : ()
    ClientState.SelectedBattlegroupId = nil
    ClientState.SelectedUnitId = nil
end

return ClientState