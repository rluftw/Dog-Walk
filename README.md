# Dog Walk
An applciation that demonstrates how to build your own core data stack - a customizable wrapper around the four classes in core data. 

### Materials covered
====================
- The four classes in core data that make up the stack
    - *NSManagedObjectModel* - Represents each object type in your app’s data model, the properties they can have, and the relationship between them
    - *NSPersistentStore* - Reads and writes data to whichever storage method you’ve decided to use.
        #### Different types of store types
        - NSQLiteStoreType
        - NSXMLStoreType
        - NSBinaryStoreType
        - NSInMemoryStoreType
    - *NSPersistentStoreCoordinator* - The bridge between the managed object model and the persistent store. It is responsible for using the model and the persistent stores to do most of the hard work in Core Data.
    - *NSManagedObjectContext* - A context is an in-memory scratchpad for working with your managed objects.
- Data deletion from core data
- Relationships
    - To one
    - To many
- CRUD opertations