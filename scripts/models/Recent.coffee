Spine = require 'Spine'

Subject = require 'models/Subject'

class Recent extends Spine.Model
  @configure 'Recent', 'subject', 'latitude', 'longitude', 'createdAt'

  @latest: (collection = @all()) ->
    sorted = collection.sort (a, b) -> return a.createdAt < b.createdAt
    sorted[0]

exports = Recent
