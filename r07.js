document.body.innerHTML = ''
const link = document.createElement("link");
link.rel = "stylesheet";
link.href = "https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/css/bootstrap.min.css";
link.integrity = "sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm";
link.crossOrigin = "anonymous"
document.head.appendChild(link);


const fetchData = async () => {
  const response1 = await fetch('https://my.bible.com/users/DvdGonzalez/_cards.json?page=1');
  let data = await response1.json();

  const response2 = await fetch('https://my.bible.com/users/DvdGonzalez/_cards.json?page=2');
  data = data.concat(await response2.json());


  let notes = data.filter(e => e.kind === 'note')
    .map(el => ({
      date: new Date(el.object.created_dt).toLocaleDateString(),
      time: new Date(el.object.created_dt).toLocaleTimeString(),
      reference: el.object.references.map(r => r.human).join(', '),
      note: el.object.content
    }));


  notes = notes.filter(note => {
    const date = new Date(note.date);
    const month = date.getMonth();
    const year = date.getFullYear();

    const today = new Date();
    const currentMonth = today.getMonth();
    const currentYear = today.getFullYear();

    return month === currentMonth && year === currentYear;
  });

  let highlights = data.filter(e => e.kind === 'highlight')
    .map(el => ({
      date: new Date(el.object.created_dt).toLocaleDateString(),
      time: new Date(el.object.created_dt).toLocaleTimeString(),
      reference: el.object.references.map(r => r.human).join(', '),
      note: 'Promise'
    }));

  highlights = highlights.filter(highlight => {
    const date = new Date(highlight.date);
    const month = date.getMonth();
    const year = date.getFullYear();

    const today = new Date();
    const currentMonth = today.getMonth();
    const currentYear = today.getFullYear();

    return month === currentMonth && year === currentYear;
  });

  const notesMap = notes.concat(highlights)
    .reduce((map, obj) => {
      const date = obj.date;
      if (!map[date]) {
        map[date] = [];
      }
      map[date].push(obj);
      return map;
    }, {});


  for (const key in notesMap) {

    notesMap[key].sort((a, b) => {
      return new Date("1970/01/01 " + a.time) - new Date("1970/01/01 " + b.time);
    }).sort((a, b) => {
      if (a.note === 'Promise') {
        return 1;
      }
      if (b.note === 'Promise') {
        return -1;
      }
    });
  }

  let mergedNotes = Object.values(notesMap).reduce((acc, curr) => {
    for (const item of curr) {
      const date = item.date;
      const time = item.time;
      const references = item.reference;
      const notes = item.note;

      if (acc[date]) {
        acc[date].time += `<br><br>${time}`;
        acc[date].references += `<br><br>${references}`;
        acc[date].notes += `<br><br>${notes}`;
        continue;
      }

      acc[date] = {
        date: date,
        time: time,
        references: references,
        notes: notes
      };
    }

    return acc;
  }, {});



  // Create a table element
  const table = document.createElement('table');

  // Add the Bootstrap table class styles
  table.classList.add('table');
  table.classList.add('table-striped');

  // Create a table header row element
  const tableHeader = document.createElement('thead');
  const headerRow = document.createElement('tr');

  // Create table header cells and add them to the table header row
  const dateHeader = document.createElement('th');
  dateHeader.textContent = 'Date';
  headerRow.appendChild(dateHeader);

  const timeHeader = document.createElement('th');
  timeHeader.textContent = 'Time';
  headerRow.appendChild(timeHeader);

  const referenceHeader = document.createElement('th');
  referenceHeader.textContent = 'Reference';
  headerRow.appendChild(referenceHeader);

  const notesHeader = document.createElement('th');
  notesHeader.textContent = 'Notes';
  headerRow.appendChild(notesHeader);

  // Add the table header row to the table
  tableHeader.appendChild(headerRow);
  table.appendChild(tableHeader);

  // Create a table body element
  const tableBody = document.createElement('tbody');


  // Create table rows and cells and add them to the table body
  for (const note of Object.values(mergedNotes)) {
    const itemRow = document.createElement('tr');

    const dateRow = document.createElement('td');
    dateRow.textContent = note.date;
    itemRow.appendChild(dateRow);

    const timeRow = document.createElement('td');
    timeRow.innerHTML = note.time;
    itemRow.appendChild(timeRow);

    const referenceRow = document.createElement('td');
    referenceRow.innerHTML = note.references;
    itemRow.appendChild(referenceRow);

    const notesRow = document.createElement('td');
    notesRow.innerHTML = note.notes.replace(/->/g, '➜');
    itemRow.appendChild(notesRow);

    tableBody.appendChild(itemRow);
  }

  // Add the table body to the table
  table.appendChild(tableBody);

  // Add the table to the page

  document.body.appendChild(table);

  var tableCells = document.querySelectorAll(".table td");
  tableCells.forEach(function (cell) { cell.style.minWidth = "120px"; });
}


fetchData();







// javascript:(function () {document.body.innerHTML="";const link=document.createElement("link");link.rel="stylesheet",link.href="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/css/bootstrap.min.css",link.integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm",link.crossOrigin="anonymous",document.head.appendChild(link);const fetchData=async()=>{const e=await fetch("https://my.bible.com/users/DvdGonzalez/_cards.json?page=1");let t=await e.json();const n=await fetch("https://my.bible.com/users/DvdGonzalez/_cards.json?page=2");t=t.concat(await n.json());let o=t.filter((e=>"note"===e.kind)).map((e=>({date:new Date(e.object.created_dt).toLocaleDateString(),time:new Date(e.object.created_dt).toLocaleTimeString(),reference:e.object.references.map((e=>e.human)).join(", "),note:e.object.content})));o=o.filter((e=>{const t=new Date(e.date),n=t.getMonth(),o=t.getFullYear(),a=new Date,c=a.getMonth(),r=a.getFullYear();return n===c&&o===r}));let a=t.filter((e=>"highlight"===e.kind)).map((e=>({date:new Date(e.object.created_dt).toLocaleDateString(),time:new Date(e.object.created_dt).toLocaleTimeString(),reference:e.object.references.map((e=>e.human)).join(", "),note:"Promise"})));a=a.filter((e=>{const t=new Date(e.date),n=t.getMonth(),o=t.getFullYear(),a=new Date,c=a.getMonth(),r=a.getFullYear();return n===c&&o===r}));const c=o.concat(a).reduce(((e,t)=>{const n=t.date;return e[n]||(e[n]=[]),e[n].push(t),e}),{});for(const e in c)c[e].sort(((e,t)=>new Date("1970/01/01 "+e.time)-new Date("1970/01/01 "+t.time))).sort(((e,t)=>"Promise"===e.note?1:"Promise"===t.note?-1:void 0));let r=Object.values(c).reduce(((e,t)=>{for(const n of t){const t=n.date,o=n.time,a=n.reference,c=n.note;e[t]?(e[t].time+=`<br><br>${o}`,e[t].references+=`<br><br>${a}`,e[t].notes+=`<br><br>${c}`):e[t]={date:t,time:o,references:a,notes:c}}return e}),{});const d=document.createElement("table");d.classList.add("table"),d.classList.add("table-striped");const l=document.createElement("thead"),i=document.createElement("tr"),s=document.createElement("th");s.textContent="Date",i.appendChild(s);const m=document.createElement("th");m.textContent="Time",i.appendChild(m);const p=document.createElement("th");p.textContent="Reference",i.appendChild(p);const h=document.createElement("th");h.textContent="Notes",i.appendChild(h),l.appendChild(i),d.appendChild(l);const u=document.createElement("tbody");for(const e of Object.values(r)){const t=document.createElement("tr"),n=document.createElement("td");n.textContent=e.date,t.appendChild(n);const o=document.createElement("td");o.innerHTML=e.time,t.appendChild(o);const a=document.createElement("td");a.innerHTML=e.references,t.appendChild(a);const c=document.createElement("td");c.innerHTML=e.notes.replace(/->/g,"➜"),t.appendChild(c),u.appendChild(t)}d.appendChild(u),document.body.appendChild(d),document.querySelectorAll(".table td").forEach((function(e){e.style.minWidth="120px"}))};fetchData();})();
