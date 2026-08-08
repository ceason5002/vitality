exercises = [
  { name: "Barbell Bench Press", muscle_group: :chest, equipment: :barbell, instructions: "Lie on a flat bench, lower the bar to mid-chest, press back up to full lockout." },
  { name: "Incline Dumbbell Press", muscle_group: :chest, equipment: :dumbbell, instructions: "On an incline bench, press dumbbells from shoulder height to full extension." },
  { name: "Push-Up", muscle_group: :chest, equipment: :bodyweight, instructions: "Hands under shoulders, lower chest to the floor, push back up keeping a straight body line." },
  { name: "Cable Fly", muscle_group: :chest, equipment: :cable, instructions: "Stand between two cable stacks, bring handles together in front of chest with a slight elbow bend." },
  { name: "Deadlift", muscle_group: :back, equipment: :barbell, instructions: "Hinge at the hips, grip the bar outside your knees, drive through the floor to stand tall." },
  { name: "Pull-Up", muscle_group: :back, equipment: :bodyweight, instructions: "Hang from a bar with an overhand grip, pull chin above the bar, lower under control." },
  { name: "Barbell Row", muscle_group: :back, equipment: :barbell, instructions: "Hinge forward, pull the bar to your lower ribs, squeeze your shoulder blades together." },
  { name: "Lat Pulldown", muscle_group: :back, equipment: :cable, instructions: "Pull the bar down to upper chest, keeping your torso mostly upright." },
  { name: "Seated Cable Row", muscle_group: :back, equipment: :cable, instructions: "Pull the handle to your torso, squeezing shoulder blades together at the finish." },
  { name: "Barbell Back Squat", muscle_group: :legs, equipment: :barbell, instructions: "Bar on your upper back, squat until thighs are parallel to the floor, drive back up." },
  { name: "Romanian Deadlift", muscle_group: :legs, equipment: :barbell, instructions: "Keep legs mostly straight, hinge at the hips lowering the bar along your legs, feel a hamstring stretch." },
  { name: "Leg Press", muscle_group: :legs, equipment: :machine, instructions: "Press the platform away by extending your knees and hips, don't lock out fully." },
  { name: "Walking Lunge", muscle_group: :legs, equipment: :dumbbell, instructions: "Step forward into a lunge, back knee near the floor, alternate legs while walking forward." },
  { name: "Leg Extension", muscle_group: :legs, equipment: :machine, instructions: "Extend your knees against the pad until legs are straight, lower under control." },
  { name: "Leg Curl", muscle_group: :legs, equipment: :machine, instructions: "Curl the pad toward your glutes by bending your knees, lower under control." },
  { name: "Overhead Press", muscle_group: :shoulders, equipment: :barbell, instructions: "Press the bar from shoulder height straight overhead, keeping your core tight." },
  { name: "Dumbbell Lateral Raise", muscle_group: :shoulders, equipment: :dumbbell, instructions: "Raise dumbbells out to the sides to shoulder height, slight bend in the elbows." },
  { name: "Face Pull", muscle_group: :shoulders, equipment: :cable, instructions: "Pull the rope toward your face, elbows high, focusing on the rear delts." },
  { name: "Arnold Press", muscle_group: :shoulders, equipment: :dumbbell, instructions: "Press dumbbells overhead while rotating palms from facing you to facing forward." },
  { name: "Barbell Curl", muscle_group: :arms, equipment: :barbell, instructions: "Curl the bar up by flexing your elbows, keep upper arms still." },
  { name: "Dumbbell Hammer Curl", muscle_group: :arms, equipment: :dumbbell, instructions: "Curl dumbbells with a neutral grip, palms facing each other throughout." },
  { name: "Tricep Pushdown", muscle_group: :arms, equipment: :cable, instructions: "Push the bar down by extending your elbows, keep upper arms fixed at your sides." },
  { name: "Skull Crusher", muscle_group: :arms, equipment: :barbell, instructions: "Lying down, lower the bar toward your forehead by bending your elbows, extend back up." },
  { name: "Dumbbell Curl", muscle_group: :arms, equipment: :dumbbell, instructions: "Curl dumbbells up with a supinating grip, squeeze at the top." },
  { name: "Plank", muscle_group: :core, equipment: :bodyweight, instructions: "Hold a straight line from head to heels, supported on forearms and toes." },
  { name: "Hanging Leg Raise", muscle_group: :core, equipment: :bodyweight, instructions: "Hang from a bar, raise your legs to hip height or higher without swinging." },
  { name: "Cable Crunch", muscle_group: :core, equipment: :cable, instructions: "Kneel below the cable, crunch down by flexing your spine, not your hips." },
  { name: "Russian Twist", muscle_group: :core, equipment: :dumbbell, instructions: "Seated with feet off the floor, rotate a weight side to side across your torso." },
  { name: "Kettlebell Swing", muscle_group: :full_body, equipment: :kettlebell, instructions: "Hinge and hike the kettlebell back, then snap your hips forward to swing it to chest height." },
  { name: "Clean and Press", muscle_group: :full_body, equipment: :barbell, instructions: "Pull the bar from the floor to your shoulders, then press it overhead." }
]

exercises.each do |attrs|
  Exercise.find_or_create_by!(name: attrs[:name]) do |exercise|
    exercise.muscle_group = attrs[:muscle_group]
    exercise.equipment = attrs[:equipment]
    exercise.instructions = attrs[:instructions]
  end
end

puts "Seeded #{Exercise.count} exercises."

foods = [
  { name: "Chicken Breast, cooked", serving_size_qty: 100, serving_size_unit: "g", calories: 165, protein_g: 31, carbs_g: 0, fat_g: 3.6 },
  { name: "Chicken Thigh, cooked", serving_size_qty: 100, serving_size_unit: "g", calories: 209, protein_g: 26, carbs_g: 0, fat_g: 10.9 },
  { name: "Salmon, cooked", serving_size_qty: 100, serving_size_unit: "g", calories: 208, protein_g: 20, carbs_g: 0, fat_g: 13 },
  { name: "Tuna, canned in water", serving_size_qty: 100, serving_size_unit: "g", calories: 116, protein_g: 26, carbs_g: 0, fat_g: 0.8 },
  { name: "Ground Beef 90/10, cooked", serving_size_qty: 100, serving_size_unit: "g", calories: 176, protein_g: 20, carbs_g: 0, fat_g: 10 },
  { name: "Egg, whole", serving_size_qty: 1, serving_size_unit: "egg", calories: 78, protein_g: 6, carbs_g: 0.6, fat_g: 5.3 },
  { name: "Egg White", serving_size_qty: 100, serving_size_unit: "g", calories: 52, protein_g: 11, carbs_g: 0.7, fat_g: 0.2 },
  { name: "Greek Yogurt, plain nonfat", serving_size_qty: 100, serving_size_unit: "g", calories: 59, protein_g: 10, carbs_g: 3.6, fat_g: 0.4 },
  { name: "Cottage Cheese, low fat", serving_size_qty: 100, serving_size_unit: "g", calories: 72, protein_g: 12, carbs_g: 3, fat_g: 1 },
  { name: "Milk, 2%", serving_size_qty: 100, serving_size_unit: "ml", calories: 50, protein_g: 3.3, carbs_g: 4.8, fat_g: 2 },
  { name: "White Rice, cooked", serving_size_qty: 100, serving_size_unit: "g", calories: 130, protein_g: 2.7, carbs_g: 28, fat_g: 0.3 },
  { name: "Brown Rice, cooked", serving_size_qty: 100, serving_size_unit: "g", calories: 123, protein_g: 2.6, carbs_g: 26, fat_g: 1 },
  { name: "Oats, dry", serving_size_qty: 100, serving_size_unit: "g", calories: 389, protein_g: 17, carbs_g: 66, fat_g: 7 },
  { name: "Quinoa, cooked", serving_size_qty: 100, serving_size_unit: "g", calories: 120, protein_g: 4.4, carbs_g: 21, fat_g: 1.9 },
  { name: "Sweet Potato, baked", serving_size_qty: 100, serving_size_unit: "g", calories: 90, protein_g: 2, carbs_g: 21, fat_g: 0.1 },
  { name: "Potato, baked", serving_size_qty: 100, serving_size_unit: "g", calories: 93, protein_g: 2.5, carbs_g: 21, fat_g: 0.1 },
  { name: "Whole Wheat Bread", serving_size_qty: 1, serving_size_unit: "slice", calories: 69, protein_g: 3.6, carbs_g: 12, fat_g: 0.9 },
  { name: "Banana", serving_size_qty: 1, serving_size_unit: "medium", calories: 105, protein_g: 1.3, carbs_g: 27, fat_g: 0.4 },
  { name: "Apple", serving_size_qty: 1, serving_size_unit: "medium", calories: 95, protein_g: 0.5, carbs_g: 25, fat_g: 0.3 },
  { name: "Broccoli, steamed", serving_size_qty: 100, serving_size_unit: "g", calories: 35, protein_g: 2.4, carbs_g: 7, fat_g: 0.4 },
  { name: "Spinach, raw", serving_size_qty: 100, serving_size_unit: "g", calories: 23, protein_g: 2.9, carbs_g: 3.6, fat_g: 0.4 },
  { name: "Avocado", serving_size_qty: 100, serving_size_unit: "g", calories: 160, protein_g: 2, carbs_g: 9, fat_g: 15 },
  { name: "Almonds", serving_size_qty: 28, serving_size_unit: "g", calories: 164, protein_g: 6, carbs_g: 6, fat_g: 14 },
  { name: "Peanut Butter", serving_size_qty: 32, serving_size_unit: "g", calories: 188, protein_g: 8, carbs_g: 6, fat_g: 16 },
  { name: "Olive Oil", serving_size_qty: 14, serving_size_unit: "g", calories: 119, protein_g: 0, carbs_g: 0, fat_g: 13.5 },
  { name: "Whey Protein Powder", serving_size_qty: 30, serving_size_unit: "scoop", calories: 120, protein_g: 24, carbs_g: 3, fat_g: 1 },
  { name: "Black Beans, cooked", serving_size_qty: 100, serving_size_unit: "g", calories: 132, protein_g: 8.9, carbs_g: 24, fat_g: 0.5 },
  { name: "Lentils, cooked", serving_size_qty: 100, serving_size_unit: "g", calories: 116, protein_g: 9, carbs_g: 20, fat_g: 0.4 },
  { name: "Tofu, firm", serving_size_qty: 100, serving_size_unit: "g", calories: 144, protein_g: 15, carbs_g: 3, fat_g: 8 },
  { name: "Pasta, cooked", serving_size_qty: 100, serving_size_unit: "g", calories: 131, protein_g: 5, carbs_g: 25, fat_g: 1.1 }
]

foods.each do |attrs|
  Food.find_or_create_by!(name: attrs[:name]) do |food|
    food.serving_size_qty = attrs[:serving_size_qty]
    food.serving_size_unit = attrs[:serving_size_unit]
    food.calories = attrs[:calories]
    food.protein_g = attrs[:protein_g]
    food.carbs_g = attrs[:carbs_g]
    food.fat_g = attrs[:fat_g]
    food.source = :database
  end
end

puts "Seeded #{Food.count} foods."
