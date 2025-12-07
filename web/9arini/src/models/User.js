// /models/User.js
export default class User {
  constructor({ firstName, lastName, email, phone, password }) {
    this.firstName = firstName;
    this.lastName = lastName;
    this.email = email;
    this.phone = phone;
    this.password = password;
  }
}
