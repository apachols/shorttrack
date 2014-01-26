/**
 * poly speed dating using ok cupids matching algorithm:
 *
 * http://ed.ted.com/lessons/inside-okcupid-the-math-of-online-dating-christian-rudder#review
 * 
 * 1. answers have your answer, the desired answer in your match, and the importance
 *    importance is weighted following an expodential curve, high imprtance is very high
 * 2. a person's match with another is the sum of importances (if matching) divided by the total possible
 * 3. a pairs match is the geometric mean of the two people's matches
 *    multiplied matches to the 1/n root where n is the number of questions
 *
 */

var util = function() {

	var id = 0;

	return {
		/**
		 * sum an array...
		 */
		sum : function( array ) {
			var sum = 0;
			for( var a=0; a<array.length; a++ ) {
				sum += array[a];
			}
			return sum;
		},
		/**
		 * This function is for getting unique ids in cas you want to keep track of stuff for debugging
		 */
		getId : function() {
			id++;
			return id;
		}
	};
}();

/**
 * constains the answer to a question, where the answers are a numerical id
 * @param int yourAnswer What you answered to the question
 * @param int theirAnswer What you want your matche's answer to be
 * @param int importance lower is less important, higher is important
 */
var Answer = function( yourAnswer, theirAnswer, importance ) {
	this.id = util.getId();
	this.yourAnswer = yourAnswer;
	this.theirAnswer = theirAnswer;
	this.importance = importance;
}

/**
 * @return weighted value based off importance 0-2 where higher has more weight
 */
Answer.prototype.getImportance = function() {
	if( this.importance === 0 ) {
		return 0;
	} else if( this.importance === 1 ) {
		return 1;
	} else if( this.importance === 2 ) {
		return 10;
	}
}

/**
 * compare the answer with a potential match and return the score if they are matches
 * @return int weghted importance if a match, 0 otherwise
 */
Answer.prototype.compare = function( theirAnswer ) {
	if( this.theirAnswer === theirAnswer.yourAnswer ) {
		return this.getImportance();
	}
	return 0;
}

/**
 * A person is a collection of answers, they can be compared with other people for potential matches
 * @param array of populated Answer objects
 */
var Person = function( answers ) {
	this.id = util.getId();
	this.answers = answers;
}

/**
 * @param Person otherPerson the person you are comparing against
 * @return array of scores for each answer between the two people
 */
Person.prototype.getScores = function( otherPerson ) {
	var scores = [];
	for( var a=0; a<this.answers.length; a++ ) {
		scores.push( this.answers[a].compare( otherPerson.answers[a] ));
	}
	return scores;
}	

/**
 * @return array of the total possible scores that the person could get
 */
Person.prototype.getTotals = function() {
	var totals = [];
	for( var a=0; a<this.answers.length; a++ ) {
		totals.push( this.answers[a].getImportance() );
	}
	return totals;
}

/**
 * compares another person using the ok cupid algorithm:
 * sum the scores for matching answers, divide by the total
 * @param Person otherPerson
 * @return numeric percent match between the other person and this
 */
Person.prototype.compare = function( otherPerson ) {
	var scores = this.getScores( otherPerson ),
		totals = this.getTotals(),
		score = util.sum( scores ),
		total = util.sum( totals );

	if( total === 0 ) {
		return 1; // what do here?
	}

	return score / total;
}

/**
 * Other person has a bad match percent? look for the reason why
 * @param Person
 * @return array of Answers that have the highest importance and the person doesn't match
 * @return false if there is no problem with the match!
 */
Person.prototype.getBadAnswer = function( otherPerson ) {
	var scores = this.getScores( otherPerson ),
		totals = this.getTotals();

	// look for the largest importance that has no score, this is the bad question
	// that causes the match to fail
	var maxTotal = 0;
	for( var a=0; a<totals.length; a++ ) {
		if( totals[a] > maxTotal && scores[a] === 0 ) {
			maxTotal = totals[a];
		}
	}

	// nothing significantly wrong with this match
	if( maxTotal === 0 ) {
		return false;
	}

	// find the answers associated with the importance
	var answers = [];
	for( var a=0; a<totals.length; a++ ) {
		if( totals[a] === maxTotal && scores[a] === 0 ) {
			answers.push( this.answers[a] );
		}
	}
	return answers;
}

/**
 * a possible match between two people
 * @param Person
 * @param Person
 */
var Pair = function( person1, person2 ) {
	this.id = util.getId();
	this.person1 = person1;
	this.person2 = person2;
}

/**
 * get the percent match between the match using the okcupid algorithm:
 * get each of their percent matches, and take the geometric mean
 * multiply them together and divide by the number of questions
 * @return numeric percent match
 */
Pair.prototype.compare = function() {
	var percent1 = this.person1.compare( this.person2 ),
		percent2 = this.person2.compare( this.person1 )

	return Math.pow( percent1 * percent2, 1 / this.person1.answers.length );
}

// functions for testing and stuff, you know

function getRandomAnswerX() {
	return Math.floor(Math.random() * 3) + 1;
}

function getRandomImportance() {
	return Math.floor(Math.random() * 3);
}

function getRandomAnswers( number ) {
	var answers = [];
	for( var a=0; a<number; a++ ) {
		answers.push( getRandomAnswer() );
	}
	return answers;
}

function getRandomAnswer() {
	var yourAnswer = getRandomAnswerX(),
		theirAnswer = getRandomAnswerX(),
		importance = getRandomImportance();

	return new Answer( yourAnswer, theirAnswer, importance );
}

function getPersonSet( number ) {
	var people = [];
	for( var a=0; a<number; a++ ) {
		people.push( new Person( getRandomAnswers(3)));
	}
	return people;
}

// compare two sets:

// var persons = getPersonSet( 2 );

// var pair = new Pair( persons[0], persons[1] );
// console.log( "person 1:", persons[0] );
// console.log( "person 2:", persons[1]);
// console.log( "compare:", pair.compare());


// comapre a person against another:

var person1 = new Person( getRandomAnswers(3) ),
	person2 = new Person( getRandomAnswers(3) );
console.log( "person 1:", person1);
console.log( "person 2:", person2);
console.log( "compare:", person1.compare(person2));
console.log( "bad answers:", person1.getBadAnswer(person2));


// compare two answers:

// var answer1 = getRandomAnswer(),
// 	answer2 = getRandomAnswer();

// console.log( "answer 1:", answer1 );
// console.log( "answer 2:", answer2 );
// console.log( "compare:", answer1.compare(answer2));
// console.log( "compare:", answer2.compare(answer1));


