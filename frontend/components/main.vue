<template>
<div>
  <nav class="navbar navbar-toggleable-sm navbar-light bg-faded">
    <button class="navbar-toggler navbar-toggler-right" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <a class="navbar-brand chord-practice-brand" href="/"></a>
    <div class="collapse navbar-collapse" id="navbarNav">
      <ul class="navbar-nav">
        <router-link to="/" exact tag="li" active-class="active" class="nav-item">
          <a class="nav-link">Home</a>
        </router-link>
        <router-link to="/chords" exact tag="li" active-class="active" class="nav-item">
          <a class="nav-link">Chords</a>
        </router-link>
        <router-link to="/sessions" tag="li" active-class="active" class="nav-item">
          <a class="nav-link">Practice</a>
        </router-link>
      </ul>
    </div>
  </nav>
  <div class="container-fluid">
    <router-view></router-view>
  </div>
</div>
</template>
<script>
export default {
  name: 'chord-practice'
}
</script>
