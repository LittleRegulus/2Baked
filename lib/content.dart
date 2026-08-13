import 'models.dart';

const defaultPresets = <TimerPreset>[
  TimerPreset(
    id: 'low_slow',
    name: 'Low & slow',
    note: 'More cooldown, mellow pace',
    heatSeconds: 35,
    coolSeconds: 55,
  ),
  TimerPreset(
    id: 'daily_driver',
    name: 'Daily driver',
    note: 'A balanced starting point',
    heatSeconds: 40,
    coolSeconds: 45,
  ),
  TimerPreset(
    id: 'hot_fast',
    name: 'Hot & fast',
    note: 'Shorter cooldown',
    heatSeconds: 45,
    coolSeconds: 30,
  ),
  TimerPreset(
    id: 'cold_start',
    name: 'Cold start',
    note: 'Short controlled warm-up',
    heatSeconds: 15,
    coolSeconds: 10,
  ),
];

const gearOptions = <String>[
  'Quartz banger',
  'Glass rig',
  'Puffco Peak',
  'Puffco Pivot',
  'Puffco Proxy',
  'Focus V CARTA',
  'Lookah Seahorse',
  'Nectar collector',
  'Other setup',
];

const chillPrompts = <String>[
  'Perfect timing. Take it easy and enjoy the moment.',
  'Cooldown complete. You are good to go.',
  'Your setup is ready. Slow breath, good vibes.',
  'Green light. Stay cozy and pace yourself.',
  'That is the timer. Enjoy responsibly.',
  'Ready when you are. Keep it smooth.',
];

const hypePrompts = <String>[
  'Take yo dab! It is time to get 2Baked!',
  'Banger ready. Lift off, you beautiful stoner!',
  'Take that fucking dab. Your moment is here!',
  'We have ignition. Get comfy and send that shit!',
  'Cooldown crushed. Time to get high as fuck!',
  'Wazzup! Wazzup! Your dab is ready!',
  'Hot lap complete. Take that dab and vibe out!',
  'Ding ding, motherfucker! Your dab window just opened!',
  '2Baked says go time. Blast off, legend!',
  'Houston, we are baked. Take that dab!',
];

const chillStartPrompts = <String>[
  'Settle in. Your 2Baked timer is rolling.',
  'Nice and easy. Heating starts now.',
  'Timer started. Take a breath and enjoy the ritual.',
  'Your session is underway. Keep it smooth.',
];

const hypeStartPrompts = <String>[
  'Get ready to get high as fuck. 2Baked is on the clock!',
  'Wazzup! Wazzup! Heat it up, legend!',
  'Let us get baked! Your heat timer starts right now!',
  'Banger ready? Strap in, motherfucker. We have ignition!',
  'Welcome aboard the 2Baked express. Next stop, outer space!',
  'Wake and bake energy! Fire it up and let us ride!',
];

const chillCooldownPrompts = <String>[
  'Heat is off. Let it cool.',
  'Heating complete. Give it a calm cooldown.',
  'Nice work. Now let the temperature settle.',
  'Cool phase started. Your moment is almost here.',
];

const hypeCooldownPrompts = <String>[
  'Flame down! Cool that bad boy. We are almost there!',
  'Heat crushed. Now chill, homie. Dab incoming!',
  'Wazzup! Cooldown started. Prepare for liftoff!',
  'Torch off, party on. Let that shit cool!',
  'Phase two, baby! Cool it down and get ready!',
];

const facts = <DabFact>[
  DabFact(
    title: 'A timer is a baseline',
    body:
        'Room temperature, airflow, torch strength, and glass thickness all change how quickly a piece heats and cools. Fine-tune your preset over a few sessions.',
    category: 'Technique',
  ),
  DabFact(
    title: 'Quartz can look cold',
    body:
        'Hot quartz can look exactly like cool quartz. Treat the banger and nearby metal as hot until enough time has passed and keep hands clear.',
    category: 'Safety',
    isSafety: true,
  ),
  DabFact(
    title: 'Concentrates are concentrated',
    body:
        'Cannabis extracts commonly contain much more THC than flower. Potency varies, so the label matters more than the texture or color.',
    category: 'Science',
    isSafety: true,
  ),
  DabFact(
    title: 'Trichomes make resin',
    body:
        'The tiny glandular structures on cannabis flowers are called trichomes. They produce resin containing cannabinoids and aromatic compounds.',
    category: 'Science',
  ),
  DabFact(
    title: 'Terpenes are aromatic',
    body:
        'Terpenes are scent-producing compounds found throughout nature, including citrus peels, pine trees, hops, and cannabis.',
    category: 'Science',
  ),
  DabFact(
    title: 'The entourage effect is unsettled',
    body:
        'Researchers are still studying how cannabinoids and terpenes may interact. Many popular claims go beyond what current evidence can prove.',
    category: 'Science',
  ),
  DabFact(
    title: 'Rosin skips solvents',
    body:
        'Rosin is mechanically pressed with heat and pressure rather than extracted with a chemical solvent.',
    category: 'Culture',
  ),
  DabFact(
    title: 'Live resin starts frozen',
    body:
        'Live resin is made from plant material frozen soon after harvest instead of being dried and cured first.',
    category: 'Culture',
  ),
  DabFact(
    title: 'Texture is not a potency meter',
    body:
        'Names like wax, budder, crumble, and shatter mainly describe consistency. Lab results are the useful guide to cannabinoid content.',
    category: 'Science',
  ),
  DabFact(
    title: 'Cold starts reverse the order',
    body:
        'A cold-start routine loads the material before gently heating. It uses a different rhythm than heating an empty banger and cooling it.',
    category: 'Technique',
  ),
  DabFact(
    title: 'A cap changes airflow',
    body:
        'A carb cap restricts and directs incoming air. That pressure and airflow can help move material around a heated surface.',
    category: 'Technique',
  ),
  DabFact(
    title: 'Clean gear is easier to read',
    body:
        'Residue changes heat transfer and makes visual cues harder to judge. Follow the maker’s cleaning instructions after the piece is safe to handle.',
    category: 'Technique',
  ),
  DabFact(
    title: 'Cracks are a stop sign',
    body:
        'Do not torch chipped, cracked, or stressed glass. Thermal cycling can make existing damage fail suddenly.',
    category: 'Safety',
    isSafety: true,
  ),
  DabFact(
    title: 'Use a heat-safe landing zone',
    body:
        'Keep the setup on a stable, nonflammable surface with space around the hot zone. Clear loose paper, fabric, hair, and cables first.',
    category: 'Safety',
    isSafety: true,
  ),
  DabFact(
    title: 'Point the torch away',
    body:
        'Keep flame away from people, pets, fuel, and anything that can catch fire. Follow the torch maker’s instructions and never leave it running.',
    category: 'Safety',
    isSafety: true,
  ),
  DabFact(
    title: 'Ventilation matters',
    body:
        'Use inhaled products only in a well-ventilated place and avoid exposing other people or pets to aerosol or smoke.',
    category: 'Safety',
    isSafety: true,
  ),
  DabFact(
    title: 'Do not drive high',
    body:
        'THC can affect reaction time, coordination, attention, and judgment. Plan a ride before the session and do not drive or operate machinery.',
    category: 'Safety',
    isSafety: true,
  ),
  DabFact(
    title: 'Alcohol adds impairment',
    body:
        'Combining cannabis with alcohol can increase impairment. Mixing substances makes effects less predictable.',
    category: 'Safety',
    isSafety: true,
  ),
  DabFact(
    title: 'Lock products away',
    body:
        'Store concentrates and infused products in labeled, child-resistant containers, out of sight and reach of children and pets.',
    category: 'Safety',
    isSafety: true,
  ),
  DabFact(
    title: 'Pregnancy is a no-go',
    body:
        'Public-health agencies advise avoiding THC, CBD, and cannabis during pregnancy and breastfeeding. Talk with a health professional for guidance.',
    category: 'Safety',
    isSafety: true,
  ),
  DabFact(
    title: 'Start smaller than your ego',
    body:
        'With high-potency concentrates, a smaller amount and time to assess effects can reduce the chance of an uncomfortable experience.',
    category: 'Safety',
    isSafety: true,
  ),
  DabFact(
    title: 'Tolerance changes',
    body:
        'Frequent THC use can change how strongly a familiar amount feels. A saved preset tracks timing, not potency or personal tolerance.',
    category: 'Science',
  ),
  DabFact(
    title: 'Hydration is comfort, not an antidote',
    body:
        'Water can help with dry mouth, but it does not instantly reverse intoxication. Time is the main factor.',
    category: 'Safety',
    isSafety: true,
  ),
  DabFact(
    title: 'There is no universal “safe dose”',
    body:
        'Responses vary with potency, tolerance, body, medications, and setting. A timer cannot measure a dose or guarantee safety.',
    category: 'Science',
    isSafety: true,
  ),
  DabFact(
    title: 'Labels beat guesses',
    body:
        'If products are legal where you live, use regulated, tested products and read the cannabinoid and ingredient labels.',
    category: 'Safety',
    isSafety: true,
  ),
  DabFact(
    title: 'Appearance cannot prove purity',
    body:
        'Clarity, color, and smell do not rule out contaminants. Testing and trustworthy sourcing matter.',
    category: 'Science',
    isSafety: true,
  ),
  DabFact(
    title: 'Electronic rigs still need care',
    body:
        'Use the charger, temperature range, and cleaning method recommended for the device. Damaged batteries should not be used.',
    category: 'Safety',
    isSafety: true,
  ),
  DabFact(
    title: 'Temperature control is not exact everywhere',
    body:
        'An e-rig setting, infrared reading, and surface temperature can differ. Learn the behavior of your specific device.',
    category: 'Technique',
  ),
  DabFact(
    title: 'A thermometer and timer do different jobs',
    body:
        'A timer repeats a routine; a compatible thermometer estimates temperature. Neither replaces attention to the equipment.',
    category: 'Technique',
  ),
  DabFact(
    title: 'Thicker quartz stores more heat',
    body:
        'More material generally changes heat retention and cooldown behavior. Two bangers can need different presets with the same torch.',
    category: 'Science',
  ),
  DabFact(
    title: 'Airflow cools surfaces',
    body:
        'Fans, open windows, and outdoor conditions can change cooldown time. That is why presets work best as personal baselines.',
    category: 'Science',
  ),
  DabFact(
    title: 'Torch distance matters',
    body:
        'Moving the flame closer or farther changes heating intensity. Consistent distance and motion make a timed routine more repeatable.',
    category: 'Technique',
  ),
  DabFact(
    title: 'Keep the flame moving',
    body:
        'For equipment designed for torch heating, evenly moving the flame helps avoid concentrating heat in one small spot.',
    category: 'Technique',
  ),
  DabFact(
    title: 'Device instructions win',
    body:
        'Manufacturers design different chambers and heat cycles. Use their current manual over a generic internet timer.',
    category: 'Safety',
    isSafety: true,
  ),
  DabFact(
    title: '“710” is concentrate slang',
    body:
        'Turn 710 upside down and it resembles the word OIL. The number became a playful shorthand in concentrate culture.',
    category: 'Culture',
  ),
  DabFact(
    title: 'Hash has a long history',
    body:
        'Concentrated cannabis resin has been made in several regions for centuries; modern hardware changed the form, not the basic idea.',
    category: 'Culture',
  ),
  DabFact(
    title: '“Dab” describes a small amount',
    body:
        'The slang name comes from using a small portion of concentrate, often handled with a dedicated tool.',
    category: 'Culture',
  ),
  DabFact(
    title: 'Cannabinoids act on receptors',
    body:
        'THC produces many of its effects by interacting with cannabinoid receptors that are part of the body’s endocannabinoid system.',
    category: 'Science',
  ),
  DabFact(
    title: 'THC can affect memory and attention',
    body:
        'Acute THC effects can include changes to short-term memory, attention, coordination, and decision-making.',
    category: 'Science',
    isSafety: true,
  ),
  DabFact(
    title: 'CBD is not a free safety pass',
    body:
        'CBD is not intoxicating in the same way as THC, but it can have side effects and drug interactions. Health claims need evidence.',
    category: 'Science',
    isSafety: true,
  ),
  DabFact(
    title: 'Potency can raise risk',
    body:
        'Higher-THC products are linked with greater risk of acute problems and cannabis use disorder, especially with frequent use.',
    category: 'Safety',
    isSafety: true,
  ),
  DabFact(
    title: 'Your setting changes the experience',
    body:
        'Mood, surroundings, company, and expectations can all shape how an intoxicating experience feels.',
    category: 'Science',
  ),
  DabFact(
    title: 'Pause between rounds',
    body:
        'Effects can build. Waiting before deciding on another round gives you more information than stacking sessions immediately.',
    category: 'Safety',
    isSafety: true,
  ),
  DabFact(
    title: 'Comfort basics help',
    body:
        'A calm place, water nearby, and a trusted person can make an uncomfortable experience easier to manage.',
    category: 'Safety',
    isSafety: true,
  ),
  DabFact(
    title: 'Know when to get help',
    body:
        'Call emergency services for severe chest pain, trouble breathing, a seizure, loss of consciousness, or other alarming symptoms.',
    category: 'Safety',
    isSafety: true,
  ),
  DabFact(
    title: 'Do not improvise extraction',
    body:
        'Solvent extraction can involve fire, explosion, and toxic exposure. Do not attempt it without lawful professional facilities.',
    category: 'Safety',
    isSafety: true,
  ),
  DabFact(
    title: 'Legal rules vary',
    body:
        'Possession, age limits, public use, home growing, and transport rules change by location. Check current local law.',
    category: 'Safety',
    isSafety: true,
  ),
  DabFact(
    title: 'Session notes reveal patterns',
    body:
        'Saving heat and cooldown times makes it easier to adjust one variable at a time instead of guessing every session.',
    category: 'Technique',
  ),
  DabFact(
    title: 'Favorite means repeatable',
    body:
        'Star the routine that behaves best with your gear, then make a custom copy when the room or hardware changes.',
    category: 'Technique',
  ),
  DabFact(
    title: 'The goal is consistency',
    body:
        'A good routine is one you can repeat safely. Match the timer to your actual equipment instead of chasing someone else’s numbers.',
    category: 'Technique',
  ),
];

const sourceNotes = <String>[
  'CDC — Cannabis and Public Health',
  'NIDA — Cannabis Concentrates DrugFacts',
  'Public Health Agency of Canada — Lower-Risk Cannabis Use Guidelines',
  'FDA — Cannabis, Pregnancy, and Breastfeeding guidance',
];
