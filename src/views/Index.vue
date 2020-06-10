<template>
  <div class="index is-dark">
    <div class="columns is-centered">
      <div class="column is-three-quarters">
        <br>
        <h1 class="title has-text-white">I Stand In Solidarity.</h1>
        <p class="has-text-white">
          I am a white American, born & raised in the midwest.
        </p>
        <br>
        <p class="has-text-white">
          A portion of our country's people continue to suffer from a system of injustice and oppression that spans back many generations and hundreds of years. I believe it's a shameful indifference of so many people like myself that has allowed racism to flourish, and I will accept it no more.
        </p>
        <br>
        <p class="has-text-white">
          I stand in solidarity with <b>any American</b> seeking equal rights, and pledge to seek your equality wherever and whenever I can. This world is hard, and you are all my brothers and sisters too - now more than ever we need unity and healing, not divisiveness and violence.
        </p>
        <br>
        <div class="heart-container has-text-centered">
          <p :class="{beat}" class="heart">🖤</p>
        </div>
        <div class="has-text-centered">
          <button @click="sendBeat" class="button is-dark">I Stand With You</button>
          <p class="button-info has-text-white">This heart is our hearts, beating in unison. Every time that button is clicked by someone it beats for all of us.</p>
          <p class="has-text-white">
            There are
            <b v-if="$store.connected_count > 0">{{ numberWithCommas($store.connected_count) }}</b>
            <span v-else>no</span>
            others here right now and this heart has beat
            <b>{{ numberWithCommas($store.processed_beats) }}</b>
            times in solidarity.
          </p>
          <p class="has-text-white"><b>You are not alone. You are loved. You are equal.</b></p>
        </div>
      </div>
    </div>
    <hr>
    <div class="columns is-halfheight is-gapless">
      <div class="column vertical-center">
        <h1 class="title has-text-white">This man was George Floyd</h1>
        <p class="has-text-white">On May 25, 2020, 4 Minnesota police officers, piled on this man for <a href="https://8m46s.com/">8 minutes and 46 seconds</a>, putting pressure on his lungs, heart, and neck until he slowly and painfully asphyxiated. Please, watch <a href="https://www.youtube.com/watch?v=vksEJR9EPQ8">this video</a> in its entirety so you can understand why people are hurting.</p>
      </div>
      <div class="column vertical-center">
        <div class="content">
          <img class="image" src="../assets/george_floyd.png">
        </div>
      </div>
    </div>
    <div class="columns is-halfheight reversed is-gapless">
      <div class="column vertical-center">
        <div class="content">
          <img class="image scaled" src="../assets/breonna_taylor.png">
        </div>
      </div>
      <div class="column vertical-center aligned-left">
        <h1 class="title has-text-white">This woman was Breonna Taylor</h1>
        <p class="has-text-white"><a href="https://www.cnn.com/2020/05/21/us/breonna-taylor-death-police-changes-trnd/index.html">Shortly after midnight on March 12, 2020</a>, Louisville police executed a <a href="https://en.wikipedia.org/wiki/No-knock_warrant">"no knock" warrent</a> at her residence, which ended with her being shot <b>8 times</b> by officers. She was an EMT, caring for those who needed her most in her community as the Coronavirus pandemic was going into full force.</p>
      </div>
      <div class="is-clearfix"></div>
    </div>
    <div class="columns is-halfheight is-gapless">
      <div class="column vertical-center">
        <h1 class="title has-text-white">This man was Ahmaud Arbery</h1>
        <p class="has-text-white">On Feb 23, 2020, Mr. Arbery was <a href="https://www.nytimes.com/article/ahmaud-arbery-shooting-georgia.html">running through a neighborhood</a> close to his house and drew the attention of 2 men who suspected him of being responsible for a string of recent break-ins. After equipping themselves with a shotgun and a .357 magnum and following him, they engaged Mr. Arbery - ultimately resulting in a struggle ending with him being fatally shot by one of the men.</p>
      </div>
      <div class="column vertical-center">
        <div class="content">
          <img class="image scaled" src="../assets/ahmaud_arbery.jpg">
        </div>
      </div>
      <div class="is-clearfix"></div>
    </div>
    <div class="columns is-gapless is-centered is-halfheight">
      <div class="column is-three-quarters vertical-center">
        <h1 class="title has-text-white">This needs to stop.</h1>
        <h2 class="subtitle has-text-white">Please, for the sake of these Americans and others who have lost their lives or had their liberties stripped away, ensure you're <a href="https://www.vote.org/register-to-vote/">registered to vote</a>, and consider supporting <a href="https://www.aclu.org/">The ACLU</a> and/or the <a href="https://www.innocenceproject.org/">Innocence project</a></h2>
      </div>
      <div class="is-clearfix"></div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Index',
  components: {
  },
  data() {
    return {
      beat: false,
      totalCount: null,
      beats: [],
    }
  },
  mounted() {
    this.$bus.$on('ping', () => {
      this.$store.processed_beats += 1
      if (this.beats.length < 500) {
        this.beats.push(true)
      }
    })
    this.$bus.$on('new_connection', () => {
      console.log('New person joined, incrementing connected count.')
      this.$store.connected_count += 1
    })
    this.$bus.$on('disconnected_client', () => {
      console.log('Someone left, decrementing connected count.')
      this.$store.connected_count -= 1
    })
    this.readBeat()
  },
  methods: {
    numberWithCommas(num) {
      return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')
    },
    readBeat() {
      if (this.beats.length > 0) {
        this.beats.pop()
        this.beatHeart()
          .then(() => {
            setTimeout(this.readBeat, 200)
          })
      } else {
        setTimeout(this.readBeat, 200)
      }
    },
    sendBeat() {
      this.$bus.$emit('heartbeat')
      this.beats.push(true)
    },
    beatHeart() {
      this.beat = true
      return new Promise((resolve) => {
        setTimeout(() => {
          this.beat = false
          resolve()
        }, 200)
      })
    },
  },
};
</script>

<style lang="scss">
  @import '../../node_modules/bulma/sass/utilities/_all';

  .index{
    background: #0d0d0d;
    padding: 1rem;
    .button[disabled], .file-cta[disabled], .file-name[disabled], .input[disabled], .pagination-ellipsis[disabled], .pagination-link[disabled], .pagination-next[disabled], .pagination-previous[disabled], .select fieldset[disabled] select, .select select[disabled], .textarea[disabled], fieldset[disabled] .button, fieldset[disabled] .file-cta, fieldset[disabled] .file-name, fieldset[disabled] .input, fieldset[disabled] .pagination-ellipsis, fieldset[disabled] .pagination-link, fieldset[disabled] .pagination-next, fieldset[disabled] .pagination-previous, fieldset[disabled] .select select, fieldset[disabled] .textarea{
      cursor: auto;
    }
    .vertical-center{
      display: flex;
      justify-content: center;
      flex-direction: column;
      align-items: center;
    }
    .columns.is-halfheight{
      min-height: 50vh;
      padding: 0 5rem;
      display: flex;
      @include until($tablet){
        padding: 1rem;
        flex-direction: column-reverse;
        .column{
          flex-basis: unset;
        }
        &.reversed{
          flex-direction: column;
        }
        img{
          max-width: 75vw;
          max-height: 33vh;
        }
      }
    }
    a{
      color: white;
      border-bottom: 1px solid white;
    }
    img{
      max-width: 75vw;
      max-height: 50vh;
    }
    img.scaled{
      @include until($tablet){
        max-width: 80vw;
      }
      max-width: 300px;
    }
    .button-info{
      margin-top: 1.5rem;
    }
    .heart-container{
      .heart{
        font-size: 5rem;
        transition: text-shadow 200ms ease-out;
        text-shadow: 0 0 0 rgba(255, 255, 255, 1);
        &.beat{
          text-shadow: 0 0 30px rgba(255, 255, 255, 1);
        }
      }
    }
  }
</style>
