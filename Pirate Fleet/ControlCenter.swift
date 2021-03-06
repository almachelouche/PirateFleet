//
//  ControlCenter.swift
//  Pirate Fleet
//
//  Created by Jarrod Parkes on 9/2/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

struct GridLocation {
    let x: Int
    let y: Int
}

struct Ship {
    let length: Int
    let location: GridLocation
    let isVertical: Bool
    let isWooden: Bool
    

// TODO: Add the computed property, cells.
 var cells: [GridLocation] {
  get {
//            // Hint: These two constants will come in handy
    let start = self.location
    let end: GridLocation = ShipEndLocation(self)
    
//            
//            // Hint: The cells getter should return an array of GridLocations.
    var occupiedCells = [GridLocation]()
    if isVertical {
        for y in start.y...end.y {
            occupiedCells.append(GridLocation(x:start.x, y: y))
        }
    } else {
        for x in start.x...end.x {
            occupiedCells.append(GridLocation(x: x, y: start.y))
        }
    }
    return occupiedCells

}
    }


    var hitTracker: HitTracker
// TODO: Add a getter for sunk. Calculate the value returned using hitTracker.cellsHit.
    var sunk: Bool {
        get {
            var hitCells = 0
            for cell in cells {
                if hitTracker.cellsHit[cell] == true {
                    hitCells = hitCells+1
                }
            }
                if hitCells == cells.count {
                    return true
                }
                 else {
                    return false
                }
    
            return sunk
    }
    }


// TODO: Add custom initializers
    init(length: Int, location: GridLocation, isVertical: Bool, hitTracker: HitTracker) {
        self.length = length
        self.location = GridLocation(x: location.x, y: location.y)
        self.isVertical = isVertical
        self.isWooden = false
        self.hitTracker = HitTracker()
 }

    init(length: Int, location: GridLocation, isVertical: Bool, isWooden: Bool) {
        self.length = length
        self.location = GridLocation(x:location.x, y: location.y)
        self.isVertical = isVertical
        self.isWooden = isWooden
        self.hitTracker = HitTracker()
    }
    init(length: Int, location: GridLocation, isVertical: Bool, isWooden: Bool, hitTracker: HitTracker) {
        self.length = length
        self.location = GridLocation(x:location.x, y: location.y)
        self.isVertical = isVertical
        self.isWooden = isWooden
        self.hitTracker = HitTracker()
    }
}


// TODO: Change Cell protocol to PenaltyCell and add the desired properties
protocol penaltyCell {
    var location: GridLocation {get}
    var guranteeHit : Bool {get set}
    var penaltyText : String {get}
}

// TODO: Adopt and implement the PenaltyCell protocol
struct Mine: penaltyCell {
    var guranteeHit : Bool = false
    var penaltyText : String = "You've hit a mine!"
    let location: GridLocation
    

}

// TODO: Adopt and implement the PenaltyCell protocol
struct SeaMonster: penaltyCell {
    let location: GridLocation
    var guranteeHit : Bool = true
    var penaltyText : String = "The sea monster is coming for you!"
}

class ControlCenter {
    
    func placeItemsOnGrid(human: Human) {
        
        let smallShip = Ship(length: 2, location: GridLocation(x: 3, y: 4), isVertical: true, isWooden: false)
        human.addShipToGrid(smallShip)
        
        let mediumShip1 = Ship(length: 3, location: GridLocation(x: 0, y: 0), isVertical: false, isWooden: false)
        human.addShipToGrid(mediumShip1)
        
        let mediumShip2 = Ship(length: 3, location: GridLocation(x: 3, y: 1), isVertical: false, isWooden: false)
        human.addShipToGrid(mediumShip2)
        
        let largeShip = Ship(length: 4, location: GridLocation(x: 6, y: 3), isVertical: true, isWooden: false)
        human.addShipToGrid(largeShip)
        
        let xLargeShip = Ship(length: 5, location: GridLocation(x: 7, y: 2), isVertical: true, isWooden: false)
        human.addShipToGrid(xLargeShip)
        
        let mine1 = Mine(guranteeHit : Bool, penaltyText: String, location: GridLocation(x: 6, y: 0))
        human.addMineToGrid(mine1)
        
        let mine2 = Mine(guranteeHit: Bool, penaltyText: <#String#>,  location: GridLocation(x: 3, y: 3))
        human.addMineToGrid(mine2)
        
        let seamonster1 = SeaMonster(location: GridLocation(x: 5, y: 6), guranteeHit: true,  penaltyText: <#String#>)
        human.addSeamonsterToGrid(seamonster1)
        
        let seamonster2 = SeaMonster(location: GridLocation(x: 2, y: 2), guranteeHit: true, penaltyText: <#String#> )
        human.addSeamonsterToGrid(seamonster2)
    }
    
    func calculateFinalScore(_ gameStats: GameStats) -> Int {
        
        var finalScore: Int
        
        let sinkBonus = (5 - gameStats.enemyShipsRemaining) * gameStats.sinkBonus
        let shipBonus = (5 - gameStats.humanShipsSunk) * gameStats.shipBonus
        let guessPenalty = (gameStats.numberOfHitsOnEnemy + gameStats.numberOfMissesByHuman) * gameStats.guessPenalty
        
        finalScore = sinkBonus + shipBonus - guessPenalty
        
        return finalScore
    }
}
