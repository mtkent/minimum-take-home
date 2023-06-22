# minimum-take-home

**How to Run**

This is a Ruby app run with Sinatra, all you need to do is run `ruby app.rb` in a console (with all of the ruby dependencies installed) and go to localhost:4567 to view the table. 
You can also run this code locally to view the emissions using the `get_` methods to see the data yourself:

<img width="578" alt="image" src="https://github.com/mtkent/minimum-take-home/assets/11528947/f781fa65-f4a0-4bdf-a4ce-5e91f42ee02f">


The table on localhost can be sorted by all of the columns, as well as filtered using the search boxes (scope, category on the top left, all of them, including activity on the top right)
<img width="945" alt="image" src="https://github.com/mtkent/minimum-take-home/assets/11528947/a8d51ecf-2035-4b07-9164-aa6bfbf69660">

Note about "grouped by activity (i.e. aggregating CO2e emissions per activity type)" - I wasn't sure exactly what this should look like, so I've set this up so you can search for an activity and it'll give you the total CO2 at the bottom.
<img width="953" alt="image" src="https://github.com/mtkent/minimum-take-home/assets/11528947/5702b15c-9d51-42b9-b8c2-a457ca7d2e25">

**Testing and next steps**

Since I didn't want to spend too much time on this (getting the frontend set up already took me a while), I didn't write any tests. I manually looked at all of the data from IRB to see that it was reasonable, as well as testing out the frontend with the sorting, filtering. It seems to be working well but if this were production code I would definitely include unit tests on the backend, as well as something to test the frontend functionality. 

I also put this all into two files, one for displaying the table and one for everything else. This should be a few classes, like the Emission object should go on its own, and I would also want to think more deeply about pulling shared code out into helper methods. 
