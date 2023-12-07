//
//  Photos.swift
//  Navigation
//
//  Created by Алексей Голованов on 28.05.2023.
//

import UIKit

func makePhotos() -> [String] {
    [
        "Profile_picture",
        "Dewey",
        "Donald",
        "Huey",
        "Ma_Beagle",
        "Louie",
        "Babyface_Beagle",
        "Bankjob_Beagle",
        "Bouncer_Beagle",
        "Bugle_Beagle",
        "Daisy_Duck",
        "Dijon",
        "Duckworth",
        "Gandra_Dee",
        "Gladstone_Gander",
        "Goldie",
        "Gyro_Gearloose",
        "Launchpad_McQuack",
        "Ludwig_von_Drake",
        "Magica_De_Spell"
    ]
}

func makePhotos() -> [UIImage] {
    var photos: [UIImage] = []
    makePhotos().forEach({photos.append(UIImage(named: $0)!)})
    return photos
}
