# Project 2 - *SuperCoolYelp*

**SuperCoolYelp** is a Yelp search app using the [Yelp API](http://www.yelp.com/developers/documentation/v2/search_api).

Time spent: **30** hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] Search results page
   - [x] Table rows should be dynamic height according to the content height.
   - [x] Custom cells should have the proper Auto Layout constraints.
   - [x] Search bar should be in the navigation bar (doesn't have to expand to show location like the real Yelp app does).
- [x] Filter page. Unfortunately, not all the filters are supported in the Yelp API.
   - [x] The filters you should actually have are: category, sort (best match, distance, highest rated), distance, deals (on/off).
   - [x] The filters table should be organized into sections as in the mock.
   - [x] You can use the default UISwitch for on/off states.
   - [x] Clicking on the "Search" button should dismiss the filters page and trigger the search w/ the new filter settings.
   - [x] Display some of the available Yelp categories (choose any 3-4 that you want).

The following **optional** features are implemented:

- [x] Search results page
   - [x] Infinite scroll for restaurant results.
- [x] Filter page
   - [x] Implement a custom switch instead of the default UISwitch.
   - [x] Distance filter should expand as in the real Yelp app

The following **additional** features are implemented:

- [x] Add row numbers to results name, like the real Yelp app`
- [x] Get and use user location (without displaying map)


Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. I'd like to know how people organized their filters pages and what structures they used.
2. I'd like to talk more about the infinite scrolling and how to use the offset and limit parameters. 

## Video Walkthrough

Here's a walkthrough of implemented user stories:  
<img src='http://i.imgur.com/xxLQFN1.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />  
<img src='http://i.imgur.com/fD2jpHu.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />  
<img src='http://i.imgur.com/ZsrcuHm.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />  

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Challenges:  
-Creating the dropdown cells was very challenging, and took me nearly 2 days.  
-I'd tried to use the newest version of the Yelp API, V3, but realized it would take way more time than we're afforded to finish the project. https://www.yelp.com/developers/documentation/v3/authentication, https://www.yelp.com/developers/documentation/v3/get_started  

## License

    Copyright [2017] [Eden Shapiro]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.


["Checked"](https://thenounproject.com/search/?q=circle%20check&i=214747) icon by Michelle Fosse from [the Noun Project](http://thenounproject.com/)  
["Circle"](https://thenounproject.com/search/?q=circle&i=1166285) icon by Zaff Studio from [the Noun Project](http://thenounproject.com/)  
["Dropdown"](https://thenounproject.com/search/?q=dropdown&i=1270388) icon by Trident from [the Noun Project](http://thenounproject.com/)  
