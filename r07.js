let currentPage = 1
let enableInfiniteScroll = false

const loadBoostrap = () => {
  const link = document.createElement('link')
  link.rel = 'stylesheet'
  link.href = 'https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/css/bootstrap.min.css'
  link.integrity = 'sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm'
  link.crossOrigin = 'anonymous'
  document.head.appendChild(link)
}

const createTable = () => {
  const table = document.createElement('table')

  // Add the Bootstrap table class styles
  table.classList.add('table')
  table.classList.add('table-striped')
  table.classList.add('table-bordered')

  const tableHeader = document.createElement('thead')
  const headerRow = document.createElement('tr')

  // Create the table headers
  const dateHeader = document.createElement('th')
  dateHeader.textContent = 'Date'
  headerRow.appendChild(dateHeader)

  const timeHeader = document.createElement('th')
  timeHeader.textContent = 'Time'
  headerRow.appendChild(timeHeader)

  const fullTextHeader = document.createElement('th')
  fullTextHeader.textContent = 'Notes'
  headerRow.appendChild(fullTextHeader)

  tableHeader.appendChild(headerRow)
  table.appendChild(tableHeader)

  const tableBody = document.createElement('tbody')
  tableBody.id = 'table-body'
  table.appendChild(tableBody)

  // Add the table to the UI
  document.getElementById('current-ui-view').appendChild(table)
}

const buildTableRows = (data) => {
  for (const note of Object.values(data)) {
    // Create a row and add the note data in the order: date, time, full text
    const itemRow = document.createElement('tr')

    const dateRow = document.createElement('td')
    dateRow.textContent = note.date
    itemRow.appendChild(dateRow)

    const timeRow = document.createElement('td')
    timeRow.innerHTML = note.time
    itemRow.appendChild(timeRow)

    const fullTextRow = document.createElement('td')
    fullTextRow.innerHTML = note.full.replace(/->/g, '➜')
    itemRow.appendChild(fullTextRow)

    // Add the row to the table
    const tableBody = document.getElementById('table-body')
    tableBody.appendChild(itemRow)
  }

  var tableCells = document.querySelectorAll('.table td')
  tableCells.forEach(function (cell) {
    cell.style.minWidth = '120px'
  })
}

const loadPromisesVerse = async (data) => {
  return await Promise.all(
    data
      .filter((e) => e.kind === 'highlight')
      .map(async (el) => {
        const verse = await fetch(
          'https://david-gonzalez-7e9dc6.netlify.app/.netlify/functions/api/ntv/' +
            el.object.references[0].human.replace(/\s/g, '/').replace(/:/g, '/')
        )
        const verseJson = await verse.json()

        return {
          date: new Date(el.object.created_dt).toLocaleDateString(),
          time: new Date(el.object.created_dt).toLocaleTimeString(),
          reference: el.object.references.map((r) => r.human).join(', '),
          note: '<mark>' + verseJson.verse + '</mark>'
        }
      })
  )
}

const fetchData = async () => {
  loadBoostrap()

  const url = `https://my.bible.com/users/DvdGonzalez/_cards.json?page=${currentPage++}`
  const response = await fetch(url)
  let data = await response.json()

  let notes = data
    .filter((e) => e.kind === 'note')
    .map((el) => ({
      date: new Date(el.object.created_dt).toLocaleDateString(),
      time: new Date(el.object.created_dt).toLocaleTimeString(),
      reference: el.object.references.map((r) => r.human).join(', '),
      note: el.object.content
    }))

  notes = notes.filter((note) => {
    const date = new Date(note.date)
    const month = date.getMonth()
    const year = date.getFullYear()

    const today = new Date()
    const currentMonth = today.getMonth()
    const currentYear = today.getFullYear()

    return month === currentMonth && year === currentYear
  })

  let highlights = await loadPromisesVerse(data)

  highlights = highlights.filter((highlight) => {
    const date = new Date(highlight.date)
    const month = date.getMonth()
    const year = date.getFullYear()

    const today = new Date()
    const currentMonth = today.getMonth()
    const currentYear = today.getFullYear()

    return month === currentMonth && year === currentYear
  })

  const notesMap = notes.concat(highlights).reduce((map, obj) => {
    const date = obj.date
    if (!map[date]) {
      map[date] = []
    }
    map[date].push(obj)
    return map
  }, {})

  for (const key in notesMap) {
    notesMap[key]
      .sort((a, b) => {
        return new Date('1970/01/01 ' + a.time) - new Date('1970/01/01 ' + b.time)
      })
      .sort((a, b) => {
        if (a.note.includes('Promise')) {
          return 1
        }
        if (b.note.includes('Promise')) {
          return -1
        }
      })
  }

  let mergedNotes = Object.values(notesMap).reduce((acc, curr) => {
    for (const item of curr) {
      const date = item.date
      const time = item.time
      const references = item.reference
      const notes = item.note

      if (acc[date]) {
        acc[date].time += `<br><br>${time}`
        acc[date].references += `<br><br>${references}`
        acc[date].notes += `<br><br>${notes}`
        acc[date].full += `<br><br>${references} - ${notes}`
        continue
      }

      acc[date] = {
        date: date,
        time: time,
        references: references,
        notes: notes,
        full: `${references} - ${notes}`
      }
    }

    return acc
  }, {})

  return mergedNotes
}

const createButton = () => {
  const btn = document.createElement('a')
  btn.href = '#'
  btn.classList.add('yv-profile-link', 'yv-text-ellipsis')
  btn.innerHTML = '<span>Mostrar R07</span>'
  btn.addEventListener('click', async () => {
    loadBoostrap()
    document.getElementById('current-ui-view').innerHTML = ''
    const initialData = await fetchData()
    createTable()
    buildTableRows(initialData)
    enableInfiniteScroll = true
  })

  const button = document.getElementsByClassName('yv-profile-link yv-text-ellipsis')[0]

  button.parentNode.replaceChild(btn, button)
}

window.addEventListener('load', function () {
  createButton()
})

window.addEventListener('scroll', async () => {
  const { scrollHeight, scrollTop, clientHeight } = document.documentElement
  if (scrollTop + clientHeight > scrollHeight - 700) {
    const newData = await fetchData()
    buildTableRows(newData)
  }
})
