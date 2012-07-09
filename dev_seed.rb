project = Project.where(name: 'bat_detective').first

# TODO:
# if project.nil?
#   Project.create...
# end

workflows = project.workflows

# TODO:
# if workflows.count is 0
#   Workflow.create...
# end

examples = [
  'bat-feeding-buzz',
  'bat-searching-horizontal-hockey-stick',
  'bat-searching-plateau',
  'bat-searching-vertical-hockey-stick',
  'bat-searching-vertical-line'
]

tutorial_id = ''

examples.each_with_index do |filename, i|
  subject = BatDetectiveSubject.create({
    project_id: project.id,
    workflow_ids: workflows.map {|w| w.id},
    zooniverse_id: 'ABD0%06d' % i,
    metadata: {
      captured_at: rand(2.years.ago..Time.now).utc.to_s,
      temperature: [rand(20..40.0), rand(20..40.0)],
      humidity: [rand, rand],
      rain: [rand, rand],
      wind: [rand, rand],
      could_cover: [rand, rand]
    },
    coords: [
      rand(40..50.0),
      rand(-70..-60.0)
    ],
    location: {
      audio: "subjects/audio/#{filename}.mp3",
      image: "subjects/image/#{filename}.jpg"
    }
  })

  if i == 0
    subject.attributes['tutorial'] = true
    subject.save
    tutorial_id = subject.id
  end

  subject.create_redis_record
end

puts "PROJECT: #{project.id}"
puts "WORKFLOW: #{workflows.first.id}"
puts "TUTORIAL: #{tutorial_id}"
