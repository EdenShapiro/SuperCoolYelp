//
//  FiltersVC.swift
//  SuperCoolYelp
//
//  Created by Eden on 9/19/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class FiltersVC: UIViewController, UITableViewDataSource, UITableViewDelegate, FiltersCellDelegate {
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var saveAndSearchButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    
    var currentFilterValues: Preferences!
    

    // should be set by the class that instantiates this view controller
    // initialize the state of the switches to match the current preferences
    // this gets set up before loading the tableview
    var currentPrefs: Preferences! {
        didSet {
            currentFilterValues = currentPrefs
            tableView?.reloadData()
        }
    }
   
    // this method saves the current preferences so that they can be returned to the main VC
    func preferencesFromTableData() -> Preferences {
        currentFilterValues.printCurrentFilterValues()
        var returnPrefs = Preferences()
        returnPrefs = currentFilterValues
        return returnPrefs
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.YelpColors.Red
        currentPrefs = currentPrefs ?? Preferences()
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        print("in viewdidload: ")
        currentFilterValues.printCurrentFilterValues()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return currentFilterValues.sections.count
    }
    

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return ""
        case 1:
            return "Most Popular"
        case 2:
            return "Distance"
        case 3:
            return "Sort by"
        case 4:
            return "Category"
        default:
            return ""
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("inside numberOfRowsInSection")
        let filter = currentFilterValues.getFilterForRowAndSection(row: 0, section: section)
        if currentFilterValues.selectableSection(section: filter.parentGroup) {
            if !filter.expanded {
                return 1
            } else {
                return currentFilterValues.sections[section].count
            }
        }
        print(currentFilterValues.sections[section].count)
        return currentFilterValues.sections[section].count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FiltersCell") as! FiltersCell
        cell.delegate = self
        cell.filter = currentFilterValues.getFilterForRowAndSection(row: indexPath.row, section: indexPath.section)
        if currentFilterValues.selectableSection(section: indexPath.section) {
            if !cell.filter.expanded {
                let currentVal = currentFilterValues.getCurrentlySelectedValueForParentGroup(parentGroup: cell.filter.parentGroup)
                cell.filter = currentFilterValues.sections[indexPath.section][currentVal]
            }
        }
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if currentFilterValues.selectableSection(section: indexPath.section) {
            let filter = currentFilterValues.getFilterForRowAndSection(row: indexPath.row, section: indexPath.section)
            print("beginning: filter: \(filter.name)")
            print("beginning: filter.expanded: \(filter.expanded)")
            if filter.expanded {
                let currentValue = currentFilterValues.getCurrentlySelectedValueForParentGroup(parentGroup: filter.parentGroup)
                if currentValue != indexPath.row {
                    currentFilterValues.setTappedValueForGroup(value: indexPath.row, parentGroup: filter.parentGroup)
                    let currentIndexPath = IndexPath(row: currentValue, section: indexPath.section)
                    self.tableView.reloadRows(at: [indexPath, currentIndexPath], with: .automatic)
                }
            }
            currentFilterValues.reverseFilterExpansion(filter: filter)
            self.tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
            print("filter: \(filter.name)")
            print("filter.expanded: \(filter.expanded)")
        }
    }

    
    func filtersCellDidToggle(cell: FiltersCell, newValue: Bool) {
        if !currentFilterValues.selectableSection(section: cell.filter.parentGroup){
            currentFilterValues.setToggledValue(filter: cell.filter, value: newValue)
        }
    }
}


//enum FilterName : String {
//    case openNow = "Order Delivery"
//    case OfferingADeal = "Offering a Deal"
//    case HotAndNew = "Hot and New"
//    case DistanceDropDown = "Best Match"
//    case SortByDropDown = " Best Match"
//    case CategoriesDropDown = "Categories"
//    
//}

//enum Distance: String {
//    case bestMatch = "Best Match"
//    case pointThreeMiles = "0.3 miles"
//    case oneMile = "1 mile"
//    case fiveMiles = "5 miles"
//    case twentyMiles = "20 miles"
//}
//
//enum SortBy: String {
//    case bestMatch = "Best Match"
//    case distance = "Distance"
//    case rating = "Rating"
//    case mostReviewed = "Most Reviewed"
//}

class Filter {
    var name: String //Distance
    var value: Bool //
    var expanded: Bool
    var parentGroup: Int
    var identifier: Int
    var code: String?
    
    init(name: String, value: Bool, parentGroup: Int, identifier: Int, code: String?){
        self.name = name
        self.value = value
        self.parentGroup = parentGroup
        self.identifier = identifier
        self.code = code
        self.expanded = false
    }
}

class Preferences {
    
    var openNow = Filter(name: "Open Now", value: false, parentGroup: 0, identifier: 0, code: nil)
    var offeringADeal = Filter(name: "Offering a Deal", value: false, parentGroup: 1, identifier: 0, code: nil)
    var hotAndNew = Filter(name: "Hot and New", value: false, parentGroup: 1, identifier: 1, code: nil)
    var distance = [Filter(name: "Best Match", value: true, parentGroup: 2, identifier: 0, code: nil),
                    Filter(name: "0.3 miles", value: false, parentGroup: 2, identifier: 1, code: nil),
                    Filter(name: "1 mile", value: false, parentGroup: 2, identifier: 2, code: nil),
                    Filter(name: "5 miles", value: false, parentGroup: 2, identifier: 3, code: nil),
                    Filter(name: "20 miles", value: false, parentGroup: 2, identifier: 4, code: nil)]
    var currentlySelectedDistance = 0
    var sortBy = [Filter(name: "Best Match", value: false, parentGroup: 3, identifier: 0, code: nil),
                  Filter(name: "Distance", value: false, parentGroup: 3, identifier: 1, code: nil),
                  Filter(name: "Rating", value: false, parentGroup: 3, identifier: 2, code: nil),
                  Filter(name: "Most Reviewed", value: false, parentGroup: 3, identifier: 3, code: nil)]
    var currentlySelectedSortBy = 0
    
    let categories = [Filter(name:  "Afghan", value: false, parentGroup: 4, identifier: 0, code: "afghani"),
                      Filter(name:  "African", value: false, parentGroup: 4, identifier: 1, code: "african"),
                      Filter(name:  "American, New", value: false, parentGroup: 4, identifier: 2, code: "newamerican"),
                      Filter(name:  "American, Traditional", value: false, parentGroup: 4, identifier: 3, code: "tradamerican"),
                      Filter(name:  "Arabian", value: false, parentGroup: 4, identifier: 4, code: "arabian"),
                      Filter(name:  "Argentine", value: false, parentGroup: 4, identifier: 5, code: "argentine"),
                      Filter(name:  "Armenian", value: false, parentGroup: 4, identifier: 6, code: "armenian"),
                      Filter(name:  "Asian Fusion", value: false, parentGroup: 4, identifier: 7, code: "asianfusion"),
                      Filter(name:  "Asturian", value: false, parentGroup: 4, identifier: 8, code: "asturian"),
                      Filter(name:  "Australian", value: false, parentGroup: 4, identifier: 9, code: "australian"),
                      Filter(name:  "Austrian", value: false, parentGroup: 4, identifier: 10, code: "austrian"),
                      Filter(name:  "Baguettes", value: false, parentGroup: 4, identifier: 11, code: "baguettes"),
                      Filter(name:  "Bangladeshi", value: false, parentGroup: 4, identifier: 12, code: "bangladeshi"),
                      Filter(name:  "Barbeque", value: false, parentGroup: 4, identifier: 13, code: "bbq"),
                      Filter(name:  "Basque", value: false, parentGroup: 4, identifier: 14, code: "basque"),
                      Filter(name:  "Bavarian", value: false, parentGroup: 4, identifier: 15, code: "bavarian"),
                      Filter(name:  "Beer Garden", value: false, parentGroup: 4, identifier: 16, code: "beergarden"),
                      Filter(name:  "Beer Hall", value: false, parentGroup: 4, identifier: 17, code: "beerhall"),
                      Filter(name:  "Beisl", value: false, parentGroup: 4, identifier: 18, code: "beisl"),
                      Filter(name:  "Belgian", value: false, parentGroup: 4, identifier: 19, code: "belgian"),
                      Filter(name:  "Bistros", value: false, parentGroup: 4, identifier: 20, code: "bistros"),
                      Filter(name:  "Black Sea", value: false, parentGroup: 4, identifier: 21, code: "blacksea"),
                      Filter(name:  "Brasseries", value: false, parentGroup: 4, identifier: 22, code: "brasseries"),
                      Filter(name:  "Brazilian", value: false, parentGroup: 4, identifier: 23, code: "brazilian"),
                      Filter(name:  "Breakfast & Brunch", value: false, parentGroup: 4, identifier: 24, code: "breakfast_brunch"),
                      Filter(name:  "British", value: false, parentGroup: 4, identifier: 25, code: "british"),
//                      Filter(name:  "Buffets", value: false, parentGroup: 4, identifier: 0, code: "buffets"),
//                      Filter(name:  "Bulgarian", value: false, parentGroup: 4, identifier: 0, code: "bulgarian"),
//                      Filter(name:  "Burgers", value: false, parentGroup: 4, identifier: 0, code: "burgers"),
//                      Filter(name:  "Burmese", value: false, parentGroup: 4, identifier: 0, code: "burmese"),
//                      Filter(name:  "Cafes", value: false, parentGroup: 4, identifier: 0, code: "cafes"),
//                      Filter(name:  "Cafeteria", value: false, parentGroup: 4, identifier: 0, code: "cafeteria"),
//                      Filter(name:  "Cajun/Creole", value: false, parentGroup: 4, identifier: 0, code: "cajun"),
//                      Filter(name:  "Cambodian", value: false, parentGroup: 4, identifier: 0, code: "cambodian"),
//                      Filter(name:  "Canadian", value: false, parentGroup: 4, identifier: 0, code: "New)"),
//                      Filter(name:  "Canteen", value: false, parentGroup: 4, identifier: 0, code: "canteen"),
//                      Filter(name:  "Caribbean", value: false, parentGroup: 4, identifier: 0, code: "caribbean"),
//                      Filter(name:  "Catalan", value: false, parentGroup: 4, identifier: 0, code: "catalan"),
//                      Filter(name:  "Chech", value: false, parentGroup: 4, identifier: 0, code: "chech"),
//                      Filter(name:  "Cheesesteaks", value: false, parentGroup: 4, identifier: 0, code: "cheesesteaks"),
//                      Filter(name:  "Chicken Shop", value: false, parentGroup: 4, identifier: 0, code: "chickenshop"),
//                      Filter(name:  "Chicken Wings", value: false, parentGroup: 4, identifier: 0, code: "chicken_wings"),
//                      Filter(name:  "Chilean", value: false, parentGroup: 4, identifier: 0, code: "chilean"),
//                      Filter(name:  "Chinese", value: false, parentGroup: 4, identifier: 0, code: "chinese"),
//                      Filter(name:  "Comfort Food", value: false, parentGroup: 4, identifier: 0, code: "comfortfood"),
//                      Filter(name:  "Corsican", value: false, parentGroup: 4, identifier: 0, code: "corsican"),
//                      Filter(name:  "Creperies", value: false, parentGroup: 4, identifier: 0, code: "creperies"),
//                      Filter(name:  "Cuban", value: false, parentGroup: 4, identifier: 0, code: "cuban"),
//                      Filter(name:  "Curry Sausage", value: false, parentGroup: 4, identifier: 0, code: "currysausage"),
//                      Filter(name:  "Cypriot", value: false, parentGroup: 4, identifier: 0, code: "cypriot"),
//                      Filter(name:  "Czech", value: false, parentGroup: 4, identifier: 0, code: "czech"),
//                      Filter(name:  "Czech/Slovakian", value: false, parentGroup: 4, identifier: 0, code: "czechslovakian"),
//                      Filter(name:  "Danish", value: false, parentGroup: 4, identifier: 0, code: "danish"),
//                      Filter(name:  "Delis", value: false, parentGroup: 4, identifier: 0, code: "delis"),
//                      Filter(name:  "Diners", value: false, parentGroup: 4, identifier: 0, code: "diners"),
//                      Filter(name:  "Dumplings", value: false, parentGroup: 4, identifier: 0, code: "dumplings"),
//                      Filter(name:  "Eastern European", value: false, parentGroup: 4, identifier: 0, code: "eastern_european"),
//                      Filter(name:  "Ethiopian", value: false, parentGroup: 4, identifier: 0, code: "ethiopian"),
//                      Filter(name:  "Fast Food", value: false, parentGroup: 4, identifier: 0, code: "hotdogs"),
//                      Filter(name:  "Filipino", value: false, parentGroup: 4, identifier: 0, code: "filipino"),
//                      Filter(name:  "Fish & Chips", value: false, parentGroup: 4, identifier: 0, code: "fishnchips"),
//                      Filter(name:  "Fondue", value: false, parentGroup: 4, identifier: 0, code: "fondue"),
//                      Filter(name:  "Food Court", value: false, parentGroup: 4, identifier: 0, code: "food_court"),
//                      Filter(name:  "Food Stands", value: false, parentGroup: 4, identifier: 0, code: "foodstands"),
//                      Filter(name:  "French", value: false, parentGroup: 4, identifier: 0, code: "french"),
//                      Filter(name:  "French Southwest", value: false, parentGroup: 4, identifier: 0, code: "sud_ouest"),
//                      Filter(name:  "Galician", value: false, parentGroup: 4, identifier: 0, code: "galician"),
//                      Filter(name:  "Gastropubs", value: false, parentGroup: 4, identifier: 0, code: "gastropubs"),
//                      Filter(name:  "Georgian", value: false, parentGroup: 4, identifier: 0, code: "georgian"),
//                      Filter(name:  "German", value: false, parentGroup: 4, identifier: 0, code: "german"),
//                      Filter(name:  "Giblets", value: false, parentGroup: 4, identifier: 0, code: "giblets"),
//                      Filter(name:  "Gluten-Free", value: false, parentGroup: 4, identifier: 0, code: "gluten_free"),
//                      Filter(name:  "Greek", value: false, parentGroup: 4, identifier: 0, code: "greek"),
//                      Filter(name:  "Halal", value: false, parentGroup: 4, identifier: 0, code: "halal"),
//                      Filter(name:  "Hawaiian", value: false, parentGroup: 4, identifier: 0, code: "hawaiian"),
//                      Filter(name:  "Heuriger", value: false, parentGroup: 4, identifier: 0, code: "heuriger"),
//                      Filter(name:  "Himalayan/Nepalese", value: false, parentGroup: 4, identifier: 0, code: "himalayan"),
//                      Filter(name:  "Hong Kong Style Cafe", value: false, parentGroup: 4, identifier: 0, code: "hkcafe"),
//                      Filter(name:  "Hot Dogs", value: false, parentGroup: 4, identifier: 0, code: "hotdog"),
//                      Filter(name:  "Hot Pot", value: false, parentGroup: 4, identifier: 0, code: "hotpot"),
//                      Filter(name:  "Hungarian", value: false, parentGroup: 4, identifier: 0, code: "hungarian"),
//                      Filter(name:  "Iberian", value: false, parentGroup: 4, identifier: 0, code: "iberian"),
//                      Filter(name:  "Indian", value: false, parentGroup: 4, identifier: 0, code: "indpak"),
//                      Filter(name:  "Indonesian", value: false, parentGroup: 4, identifier: 0, code: "indonesian"),
//                      Filter(name:  "International", value: false, parentGroup: 4, identifier: 0, code: "international"),
//                      Filter(name:  "Irish", value: false, parentGroup: 4, identifier: 0, code: "irish"),
//                      Filter(name:  "Island Pub", value: false, parentGroup: 4, identifier: 0, code: "island_pub"),
//                      Filter(name:  "Israeli", value: false, parentGroup: 4, identifier: 0, code: "israeli"),
//                      Filter(name:  "Italian", value: false, parentGroup: 4, identifier: 0, code: "italian"),
//                      Filter(name:  "Japanese", value: false, parentGroup: 4, identifier: 8, code: "japanese"),
//                      Filter(name:  "Jewish", value: false, parentGroup: 4, identifier: 0, code: "jewish"),
//                      Filter(name:  "Kebab", value: false, parentGroup: 4, identifier: 0, code: "kebab"),
//                      Filter(name:  "Korean", value: false, parentGroup: 4, identifier: 0, code: "korean"),
//                      Filter(name:  "Kosher", value: false, parentGroup: 4, identifier: 0, code: "kosher"),
//                      Filter(name:  "Kurdish", value: false, parentGroup: 4, identifier: 0, code: "kurdish"),
//                      Filter(name:  "Laos", value: false, parentGroup: 4, identifier: 0, code: "laos"),
//                      Filter(name:  "Laotian", value: false, parentGroup: 4, identifier: 0, code: "laotian"),
//                      Filter(name:  "Latin American", value: false, parentGroup: 4, identifier: 0, code: "latin"),
//                      Filter(name:  "Live/Raw Food", value: false, parentGroup: 4, identifier: 0, code: "raw_food"),
//                      Filter(name:  "Lyonnais", value: false, parentGroup: 4, identifier: 0, code: "lyonnais"),
//                      Filter(name:  "Malaysian", value: false, parentGroup: 4, identifier: 0, code: "malaysian"),
//                      Filter(name:  "Meatballs", value: false, parentGroup: 4, identifier: 0, code: "meatballs"),
//                      Filter(name:  "Mediterranean", value: false, parentGroup: 4, identifier: 0, code: "mediterranean"),
//                      Filter(name:  "Mexican", value: false, parentGroup: 4, identifier: 0, code: "mexican"),
//                      Filter(name:  "Middle Eastern", value: false, parentGroup: 4, identifier: 0, code: "mideastern"),
//                      Filter(name:  "Milk Bars", value: false, parentGroup: 4, identifier: 0, code: "milkbars"),
//                      Filter(name:  "Modern Australian", value: false, parentGroup: 4, identifier: 0, code: "modern_australian"),
//                      Filter(name:  "Modern European", value: false, parentGroup: 4, identifier: 0, code: "modern_european"),
//                      Filter(name:  "Mongolian", value: false, parentGroup: 4, identifier: 0, code: "mongolian"),
//                      Filter(name:  "Moroccan", value: false, parentGroup: 4, identifier: 0, code: "moroccan"),
//                      Filter(name:  "New Zealand", value: false, parentGroup: 4, identifier: 0, code: "newzealand"),
//                      Filter(name:  "Night Food", value: false, parentGroup: 4, identifier: 0, code: "nightfood"),
//                      Filter(name:  "Norcinerie", value: false, parentGroup: 4, identifier: 0, code: "norcinerie"),
//                      Filter(name:  "Open Sandwiches", value: false, parentGroup: 4, identifier: 0, code: "opensandwiches"),
//                      Filter(name:  "Oriental", value: false, parentGroup: 4, identifier: 0, code: "oriental"),
//                      Filter(name:  "Pakistani", value: false, parentGroup: 4, identifier: 0, code: "pakistani"),
//                      Filter(name:  "Parent Cafes", value: false, parentGroup: 4, identifier: 0, code: "eltern_cafes"),
//                      Filter(name:  "Parma", value: false, parentGroup: 4, identifier: 0, code: "parma"),
//                      Filter(name:  "Persian/Iranian", value: false, parentGroup: 4, identifier: 0, code: "persian"),
//                      Filter(name:  "Peruvian", value: false, parentGroup: 4, identifier: 0, code: "peruvian"),
//                      Filter(name:  "Pita", value: false, parentGroup: 4, identifier: 0, code: "pita"),
//                      Filter(name:  "Pizza", value: false, parentGroup: 4, identifier: 0, code: "pizza"),
//                      Filter(name:  "Polish", value: false, parentGroup: 4, identifier: 0, code: "polish"),
//                      Filter(name:  "Portuguese", value: false, parentGroup: 4, identifier: 0, code: "portuguese"),
//                      Filter(name:  "Potatoes", value: false, parentGroup: 4, identifier: 0, code: "potatoes"),
//                      Filter(name:  "Poutineries", value: false, parentGroup: 4, identifier: 0, code: "poutineries"),
//                      Filter(name:  "Pub Food", value: false, parentGroup: 4, identifier: 0, code: "pubfood"),
//                      Filter(name:  "Rice", value: false, parentGroup: 4, identifier: 0, code: "riceshop"),
//                      Filter(name:  "Romanian", value: false, parentGroup: 4, identifier: 0, code: "romanian"),
//                      Filter(name:  "Rotisserie Chicken", value: false, parentGroup: 4, identifier: 0, code: "rotisserie_chicken"),
//                      Filter(name:  "Rumanian", value: false, parentGroup: 4, identifier: 0, code: "rumanian"),
//                      Filter(name:  "Russian", value: false, parentGroup: 4, identifier: 0, code: "russian"),
//                      Filter(name:  "Salad", value: false, parentGroup: 4, identifier: 0, code: "salad"),
//                      Filter(name:  "Sandwiches", value: false, parentGroup: 4, identifier: 0, code: "sandwiches"),
//                      Filter(name:  "Scandinavian", value: false, parentGroup: 4, identifier: 0, code: "scandinavian"),
//                      Filter(name:  "Scottish", value: false, parentGroup: 4, identifier: 0, code: "scottish"),
//                      Filter(name:  "Seafood", value: false, parentGroup: 4, identifier: 0, code: "seafood"),
//                      Filter(name:  "Serbo Croatian", value: false, parentGroup: 4, identifier: 0, code: "serbocroatian"),
//                      Filter(name:  "Signature Cuisine", value: false, parentGroup: 4, identifier: 0, code: "signature_cuisine"),
//                      Filter(name:  "Singaporean", value: false, parentGroup: 4, identifier: 0, code: "singaporean"),
//                      Filter(name:  "Slovakian", value: false, parentGroup: 4, identifier: 0, code: "slovakian"),
//                      Filter(name:  "Soul Food", value: false, parentGroup: 4, identifier: 0, code: "soulfood"),
//                      Filter(name:  "Soup", value: false, parentGroup: 4, identifier: 0, code: "soup"),
//                      Filter(name:  "Southern", value: false, parentGroup: 4, identifier: 0, code: "southern"),
//                      Filter(name:  "Spanish", value: false, parentGroup: 4, identifier: 0, code: "spanish"),
//                      Filter(name:  "Steakhouses", value: false, parentGroup: 4, identifier: 0, code: "steak"),
//                      Filter(name:  "Sushi Bars", value: false, parentGroup: 4, identifier: 0, code: "sushi"),
//                      Filter(name:  "Swabian", value: false, parentGroup: 4, identifier: 0, code: "swabian"),
//                      Filter(name:  "Swedish", value: false, parentGroup: 4, identifier: 0, code: "swedish"),
//                      Filter(name:  "Swiss Food", value: false, parentGroup: 4, identifier: 0, code: "swissfood"),
//                      Filter(name:  "Tabernas", value: false, parentGroup: 4, identifier: 0, code: "tabernas"),
//                      Filter(name:  "Taiwanese", value: false, parentGroup: 4, identifier: 0, code: "taiwanese"),
//                      Filter(name:  "Tapas Bars", value: false, parentGroup: 4, identifier: 0, code: "tapas"),
//                      Filter(name:  "Tapas/Small Plates", value: false, parentGroup: 4, identifier: 0, code: "tapasmallplates"),
//                      Filter(name:  "Tex-Mex", value: false, parentGroup: 4, identifier: 0, code: "tex-mex"),
//                      Filter(name:  "Thai", value: false, parentGroup: 4, identifier: 0, code: "thai"),
//                      Filter(name:  "Traditional Norwegian", value: false, parentGroup: 4, identifier: 0, code: "norwegian"),
//                      Filter(name:  "Traditional Swedish", value: false, parentGroup: 4, identifier: 0, code: "traditional_swedish"),
//                      Filter(name:  "Trattorie", value: false, parentGroup: 4, identifier: 0, code: "trattorie"),
//                      Filter(name:  "Turkish", value: false, parentGroup: 4, identifier: 0, code: "turkish"),
//                      Filter(name:  "Ukrainian", value: false, parentGroup: 4, identifier: 0, code: "ukrainian"),
//                      Filter(name:  "Uzbek", value: false, parentGroup: 4, identifier: 0, code: "uzbek"),
//                      Filter(name:  "Vegan", value: false, parentGroup: 4, identifier: 0, code: "vegan"),
//                      Filter(name:  "Vegetarian", value: false, parentGroup: 4, identifier: 0, code: "vegetarian"),
//                      Filter(name:  "Venison", value: false, parentGroup: 4, identifier: 0, code: "venison"),
//                      Filter(name:  "Vietnamese", value: false, parentGroup: 4, identifier: 0, code: "vietnamese"),
//                      Filter(name:  "Wok", value: false, parentGroup: 4, identifier: 0, code: "wok"),
//                      Filter(name:  "Wraps", value: false, parentGroup: 4, identifier: 0, code: "wraps"),
                      Filter(name:  "Yugoslav", value: false, parentGroup: 4, identifier: 26, code: "yugoslav")]
    
       var sections = [[Filter]]()
    
    init(){
        sections = [[openNow],
                    [offeringADeal, hotAndNew],
                    distance,
                    sortBy,
                    categories]
    }
    
    func getFilterForRowAndSection(row: Int, section: Int) -> Filter {
            return sections[section][row]
    }
    
    func selectableSection(section: Int) -> Bool {
        if section == 2 || section == 3 {
            return true
        } else {
            return false
        }
    }
    
    func reverseFilterExpansion(filter: Filter){
        for filt in sections[filter.parentGroup] {
            let temp = !filt.expanded
            filt.expanded = temp
        }
    }
    
    func getCurrentlySelectedValueForParentGroup(parentGroup: Int) -> Int {
        if parentGroup == 2 {
            return currentlySelectedDistance
        } else {
            return currentlySelectedSortBy
        }
    }
    
    func setToggledValue(filter: Filter, value: Bool){
        sections[filter.parentGroup][filter.identifier].value = value
    }
    
    func setTappedValueForGroup(value: Int, parentGroup: Int) {
        if parentGroup == 2 {
            currentlySelectedDistance = value
            for filt in distance {
                if filt.identifier == value {
                    filt.value = true
                } else {
                    filt.value = false
                }
            }
        } else { //parentGroup == 3
            currentlySelectedSortBy = value
            for filt in sortBy {
                if filt.identifier == value {
                    filt.value = true
                } else {
                    filt.value = false
                }
            }
        }
    }
    
    func printCurrentFilterValues(){
        for sec in sections{
            for fil in sec {
                print("\(fil.name): \(fil.value)")
            }
        }
    }
    
    func getDistanceEnum() -> YelpSearchRadius? {
        switch currentlySelectedDistance {
        case 0:
            return YelpSearchRadius.bestMatched
        case 1:
            return YelpSearchRadius.pointThreeMiles
        case 2:
            return YelpSearchRadius.oneMile
        case 3:
            return YelpSearchRadius.fiveMiles
        case 4:
            return YelpSearchRadius.twentyMiles
        default:
            return nil
        }
    }
    
    func getSortByEnum() -> YelpSortMode? {
        switch currentlySelectedSortBy {
        case 0:
            return YelpSortMode.bestMatched
        case 1:
            return YelpSortMode.distance
        case 2:
            return YelpSortMode.highestRated
        case 3:
            return YelpSortMode.mostReviewed
        default:
            return nil
        }
    }
    
    func getArrayOfCategories()-> [String]? {
        var returnArray = [String]()
        for filt in sections[4] {
            if filt.value {
                returnArray.append(filt.code!)
            }
        }
        if returnArray.count > 0 {
            return returnArray
        } else {
            return nil
        }
    }
    
    func getDeals() -> Bool {
        return offeringADeal.value
    }
    
    func getHotAndNew() -> Bool {
        return hotAndNew.value
    }
    
//    func getopenNow() -> Bool {
//        return openNow.value
//    }

    func getOpenNow() -> Bool {
        return openNow.value // FIXME
    }


}
