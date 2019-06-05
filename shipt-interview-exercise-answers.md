## 1. Testing Account Creation
To test this feature, I would first scope out all the parts that need to be tested. That is to create an account with:
* Facebook OAuth
* Gmail OAuth
* Email

And also to test not only when account creation succeeds, but when it fails, to test that it fails appropriately.
* incorrect email
* invalid password

Because you're using OAuth, you should mock the response to run tests quickly. Both a request test and a controller test should be used to test OAuth. 

## 2. Bug Report
a. There is no indication that a filter action is being processed by the site. This occurs when you use the modal for filtering and not the sidebar. The filter modal appears when the window width is less than or equal to 767px. By contrast, the items appear greyed out when a filter is performed through the sidebar. 
b. See Figure 1: Modal Search & Figure 2: Sidebar Search with Greyed Out Items
c. When a filter category is clicked on the modal:
* the entire modal should be greyed out
* there should be a spiraling modal gif
* the bottom "Show XX Results" button should be replaced with "Loading..."
* the "loading text should be animated, where a period is added, such that users see:
  * "Loading"
  * "Loading."
  * "Loading.."
  * "Loading..."
  * "Loading"

The entire modal should be greyed out because when a filter category is clicked, there is a moment where you cannot click on another category. If you do, then the form won't respond. This breaks the user's expectations. Instead, their should be a visual cue letting them know they cannot click on another button until the filter action finishes processing.

Additionally, there should be a visual cue that the filter action is processing, so that the user knows that work is being performed because of their click.

d. I would write it up, make a video of it, and send it by email to the party responsible. Or I would follow whatever process is in place for reporting bugs, like if there were a list, I would add it there. I would also flag this for a designer to look at. The experience is pretty delicate, so getting a 2nd opinion from a designer would be best.

e. I would give this bug a priority of 4. The functionality works fine, especially for most users who are returning and will know how it works. However, the bug creates a moment of uncertainty for new users. The bug also undermines the overall credibility of the app because it's just not a perfect experience. 

## 3. The sequence in which things are happening here is:
* user input
* post request
* view change

At each step of the process, there could be a bug that prevents the number from being saved appropriately. 

### User Input
* Perhaps the Save button is clickable, but the form does not send after it is sent once, it is disabled, and not re-enabled.
* For whatever reason the user input does not lead to a post request

### Post Request
* Once the post request is saved, it must be validated appropriately. Maybe there's some validation that prevents old numbers from being saved, like if there's an attribute that says "active: true" on the phone number, and when it tries to create a new one, it already exists, and does not switch the numbers to being "active: false" and "active: true". 

### View Change
* It's possible that the old number is cached locally for the viewer. Depending on how the data is saved, if there is a materialized view, this might be possible if the data hasn't yet propagated.

To debug the problem, I would re-create the issue, and check each of the above issues sequentially. 

## SQL
1. Stores that sell alcohol: Gettar
SELECT name FROM interview.stores
WHERE allowed_alcohol=TRUE;

2. Most expensive 2 items at store id 1: Golden Banana, Banana
SELECT products.name, store_prices.price
FROM interview.products
INNER JOIN interview.store_prices
ON interview.products.ID=interview.store_prices.product_id
WHERE store_prices.store_id=1
ORDER BY store_prices.price DESC
limit 2;

3. Products not sold at store id 2: Banana, Golden Banana, Bouquet Flowers
SELECT products.name
FROM interview.products
FULL JOIN interview.store_prices
ON interview.products.ID=interview.store_prices.product_id
WHERE products.name NOT IN (SELECT products.name
FROM interview.products
FULL JOIN interview.store_prices
ON interview.products.ID=interview.store_prices.product_id
WHERE store_id = 2);

4. Most popular item sold: Banana
SELECT product_id,
SUM(qty) AS sum
FROM interview.order_lines
GROUP BY product_id
ORDER BY sum DESC
LIMIT 1;

SELECT name FROM interview.products WHERE products.id = 2;

5. SQL statement to update the line_total field
UPDATE interview.order_lines
  set line_total = order_lines.qty * store_prices.price
FROM interview.store_prices
WHERE order_lines.product_id = store_prices.product_id
AND order_lines.store_id = store_prices.store_id;

## Automation Assessment
I tested login because I did not want to create dummy emails in Shipt's database.

1. I chose Capybara, which is a Ruby interface that can run Selenium, Webkit, or pure Ruby drivers. Using the gem webdrivers, the default is Selenium. The Capybara interface provides an easy way to write integration tests.

2. To locate the elements in my tests, I opened up my browser and used inspect element to find the elements. I would look at the HTML and decide based on what classes they have or the types of html elements they are, how to select them using the Capybara interface. 

3. Requirements and UI changes happen all the time. The main role of the UI automation isn't to re-test the functionality that should already be tested in unit tests. In fact, to test the coordination of classes, this should be done through service tests that run different scenarios and not though UI tests. UI tests should be a reality check that the final product really does work. By testing most of the functionality where the work occurs: in classes and between classes, UI testing can be the final check of confidence that the users will get a great experience. In other words, too many UI tests is the greatest driver of them being brittle. Developer conventions around styling, like using a style guide, may help reduce the brittleness of tests; however, software is always changing, so many tests will break in a situation where the reality is also changing quickly.

4. To make tests consistent and easy to debug, organize them so that each test is easy to read. For tests, this means having 4 phases in each test:
* setup
* execution
* test
* teardown

Also, use classes to create an abstraction where the page behavior becomes clear. This makes updating and reading a UI test much easier. You can also re-use functionality and only make changes in one place.