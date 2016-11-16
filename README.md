#[FaceSnap](https://teamtreehouse.com/library/build-a-selfie-app-with-swift-2)
###by Alexey Papin
<img width="400"src="https://devimages.apple.com.edgekey.net/app-store/marketing/guidelines/images/exhibit-1-3-mobile.png">

[![Latest Stable Version](https://poser.pugx.org/edward/aaa/v/stable)](https://packagist.org/packages/edward/aaa)

###About this Course

In this course we're going to build an app that is quite popular these days - a selfie app! We'll learn how to build and apply filters, how to use Core Data for more than just a single entity and how to use the device's camera to create a fun app!
What you'll learn

- Core Data
- Core Image and image rendering
- Building apps without storyboards
- Filtering data with predicates

####Taking a Selfie
`
An essential component of building a selfie app is allowing users to take pictures. There are several ways a user can end up with a photo and over the next set of videos we use the UIImagePickerController class to build this functionality. We'll revisit an important concept - delegates, and understand how we can build objects that are not tightly coupled from the get go.
`
####Adding Image Filters
`
One of the fun parts of our app is applying filters to the images we taken. Over the next set of videos, let's take a look at how we can apply various filters to an image and render it in a view. This isn't as simple as it seems and we'll look at some of the pitfalls we may run into and the resulting considerations we need to make for a great user experience.
`
####Adding Metadata to Photos
`
Storing just a selfie in an app is easy so we're going to step it up a notch and add some metadata to each photo. Over the next set of videos, we'll create an interface that allows users to add both a location and tags to the photo. Using this metadata we can later build in useful filtering functionality.
`
####Saving and Displaying Selfies
`
Now that we've finally built up the UI and logic to take a selfie and add metadata to it, let's implement the saving functionality. Over the next few videos, we'll add Core Data Entities to represent the various aspects of our model, create NSManagedObject subclasses to interact with them in code and save the photos to disk
`
####Filtering the Data
`
There is no point to adding metadata to our photos if we're not going to use them in the app. Over the next set of videos, let's implement some logic to allow a user to sort their main feed by tags. We'll do this using generic classes so they can be reused for either a location, or future metadata types should we add them. Once we have a set of tags to sort by, we'll reload the main screen dynamically!
`
